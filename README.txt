================================================================================
  SISTEMA DE REGISTRO CIVIL - REGISTRADURÍA MUNICIPAL DE NOBSA
  README - VERSIÓN 1
================================================================================

Aprendiz     : [Karen Dayana Buitrago Acosta]
Ficha        : [3171062]
Programa     : Tecnólogo en Análisis y Desarrollo de Software – ADSO
Centro       : CIMM – Regional Boyacá
Competencia  : 220501096 – Construcción del Software

================================================================================
1. MOTOR DE BASE DE DATOS ELEGIDO: SQL SERVER 2022 (SQL Server Management Studio)
================================================================================

Se eligió SQL Server 2022 con SQL Server Management Studio (SSMS) como herramienta
de administración visual.

JUSTIFICACIÓN:
SQL Server es el motor predominante en entidades del sector público colombiano
que operan sobre ecosistemas Microsoft. Una registraduría municipal encaja en ese
perfil: infraestructura Windows, mantenimiento técnico local y necesidad de
cumplimiento con estándares de integridad de datos civiles. SQL Server ofrece
transacciones ACID robustas, soporte nativo para NVARCHAR (manejo correcto de
tildes y caracteres especiales del español), y la posibilidad de escalar a
entornos empresariales sin cambiar el motor. La concurrencia de una registraduría
municipal es baja (< 50 usuarios simultáneos), lo que hace innecesario un motor
distribuido, y SQL Server Express cubre esa carga sin costo de licencia.

================================================================================
2. PASOS PARA EJECUTAR EL PROYECTO
================================================================================

REQUISITOS PREVIOS:
  - JDK 17 o superior instalado
  - Apache Tomcat 10.x
  - SQL Server 2022 Express + SSMS 19+
  - Maven 3.8+
  - IntelliJ IDEA Community o VS Code con extensión Java

PASO 1 – Preparar la base de datos en SSMS:
  a. Abrir SSMS y conectarse a la instancia local (localhost o .\SQLEXPRESS).
  b. Crear la base de datos: CREATE DATABASE registraduria_nobsa;
  c. Ejecutar el script sql/registraduria_nobsa.sql para crear las 5 tablas
     e insertar los datos de prueba.
  d. Verificar que las tablas ciudadanos, documentos_expedidos, ciudades,
     zonas_votacion y mesas_votacion existan con sus datos.

PASO 2 – Configurar db.properties:
  Editar src/main/resources/db.properties:
    db.engine=sqlserver
    sqlserver.url=jdbc:sqlserver://localhost:1433;databaseName=registraduria_nobsa;
                  encrypt=true;trustServerCertificate=true
    sqlserver.user=sa
    sqlserver.password=[TU_CONTRASEÑA]

PASO 3 – Compilar y desplegar:
  mvn clean package
  Copiar el .war generado en target/ a la carpeta webapps/ de Tomcat.
  Iniciar Tomcat: bin/startup.bat (Windows)

PASO 4 – Acceder a la aplicación:
  http://localhost:8080/registraduria-nobsa/

================================================================================
3. RESPUESTAS A LAS PREGUNTAS DE REFLEXIÓN Y ANÁLISIS
================================================================================

────────────────────────────────────────────────────────────────────────────────
SECCIÓN 12.1 – PREGUNTAS CONCEPTUALES
────────────────────────────────────────────────────────────────────────────────

PREGUNTA 1:
¿Qué ventaja concreta ofrece el patrón DAO respecto a escribir el código SQL
directamente en el Servlet? ¿Cambiarías de motor sin el patrón DAO?
¿Cuántas líneas tendrías que modificar?

RESPUESTA:
El patrón DAO establece una separación clara entre la lógica de control HTTP
(Servlet) y la lógica de acceso a datos. Esto significa que el Servlet únicamente
recibe la petición, delega la operación al DAO y redirige la respuesta; no conoce
nada sobre SQL ni conexiones. La ventaja concreta es que si se necesita cambiar el
motor de base de datos (por ejemplo, de SQL Server a PostgreSQL), solo se modifica
la clase de implementación DAO y el archivo db.properties; los Servlets y las vistas
JSP permanecen intactos.

Sin el patrón DAO, el SQL estaría embebido en los Servlets. Un cambio de motor
implicaría recorrer cada Servlet buscando cadenas de texto con consultas,
modificando credenciales y tipos de datos. En un proyecto de 5 Servlets con 4
operaciones CRUD cada uno, eso podría significar modificar entre 80 y 120 líneas
distribuidas en múltiples archivos, con alto riesgo de introducir errores. Con DAO,
ese mismo cambio se reduce a editar el archivo de propiedades y, en el peor caso,
ajustar 10 a 15 líneas en la implementación DAO.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 2:
¿Qué es JDBC y cuál es el rol del driver? ¿Por qué Supabase puede usar el mismo
driver que PostgreSQL? ¿Por qué H2 no necesita instalar ningún servidor?

RESPUESTA:
JDBC (Java Database Connectivity) es la API estándar de Java que define un conjunto
de interfaces para conectar aplicaciones Java con bases de datos relacionales. El
driver es la implementación concreta de esas interfaces para un motor específico:
traduce las llamadas Java estándar (DriverManager.getConnection, executeQuery) al
protocolo de red o al formato binario que ese motor entiende.

Supabase utiliza el mismo driver que PostgreSQL porque internamente Supabase es
PostgreSQL; la plataforma añade capas de autenticación y API REST por encima, pero
el motor subyacente es idéntico. Por tanto, el protocolo de comunicación es el
mismo y el driver org.postgresql.Driver funciona sin ningún cambio.

H2 no requiere instalar ningún servidor porque el motor entero está escrito en Java
y se ejecuta dentro de la misma JVM que la aplicación. No hay un proceso de servidor
separado ni un puerto de red que escuchar; la base de datos se inicia como parte
del proceso Java y se detiene cuando este termina.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 3:
¿Qué es un PreparedStatement y por qué es superior a construir la consulta SQL
concatenando Strings? Menciona el riesgo de seguridad específico que mitiga.

RESPUESTA:
Un PreparedStatement es una consulta SQL precompilada en la que los valores
variables se reemplazan por marcadores de posición (?). El motor de base de datos
analiza y optimiza la estructura de la consulta una sola vez; en ejecuciones
posteriores solo sustituye los parámetros, lo que también mejora el rendimiento
en consultas repetitivas.

La superioridad frente a la concatenación de Strings radica en la seguridad: la
concatenación permite ataques de SQL Injection. Si un usuario introduce como
número de documento el texto  1052345678' OR '1'='1  y ese valor se concatena
directamente en la cadena SQL, la consulta resultante devuelve todos los registros
de la tabla, eludiendo el filtro. Con PreparedStatement, ese valor se envía como
dato literal al motor, que nunca lo interpreta como código SQL. Esto convierte al
PreparedStatement en la defensa principal contra SQL Injection, la vulnerabilidad
número uno en aplicaciones web según OWASP.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 4:
El bloque try-with-resources garantiza que Connection, PreparedStatement y ResultSet
se cierren automáticamente. ¿Qué problema grave ocurriría si no se cierran?
¿Cómo se llama ese problema?

RESPUESTA:
Si las conexiones no se cierran explícitamente, permanecen abiertas en el pool o en
el servidor de base de datos indefinidamente. Dado que cada conexión consume memoria
y recursos del servidor, después de un número suficiente de peticiones el servidor
agota las conexiones disponibles y comienza a rechazar nuevas solicitudes con el
error "Too many connections" o su equivalente en cada motor. La aplicación deja de
funcionar aunque el servidor físico esté operativo.

Este problema se denomina fuga de recursos (resource leak) o, más específicamente,
fuga de conexiones (connection leak). En aplicaciones web con múltiples usuarios
simultáneos, una fuga de conexiones puede colapsar el sistema en minutos. El
bloque try-with-resources garantiza el cierre en el bloque finally implícito,
incluso cuando ocurre una excepción, eliminando este riesgo de forma elegante.

────────────────────────────────────────────────────────────────────────────────
SECCIÓN 12.2 – PREGUNTAS DE ANÁLISIS
────────────────────────────────────────────────────────────────────────────────

PREGUNTA 5:
H2 en modo memoria pierde todos los datos al reiniciar Tomcat. ¿En qué situaciones
esto es una ventaja? Da dos ejemplos de proyectos donde usarías H2 modo memoria
y dos donde usarías H2 modo archivo.

RESPUESTA:
La volatilidad de H2 en modo memoria es una ventaja cuando se necesita un estado
limpio y reproducible en cada ejecución, sin tener que limpiar manualmente la base
de datos entre pruebas.

CASOS DONDE USAR H2 MODO MEMORIA:
  1. Pruebas unitarias e integración con JUnit: cada ejecución de la suite de
     pruebas parte de una base de datos vacía (o con datos controlados via script),
     garantizando que los tests sean independientes entre sí y no se afecten por
     datos residuales de ejecuciones anteriores.
  2. Demostraciones y presentaciones del sistema: se puede arrancar la aplicación
     con datos de prueba predefinidos sin necesidad de restaurar backups ni
     ejecutar scripts de limpieza previos a cada sesión de demostración.

CASOS DONDE USAR H2 MODO ARCHIVO:
  1. Prototipo de campo con datos reales temporales: cuando un desarrollador está
     en las instalaciones del cliente capturando requisitos y necesita persistir
     algunos datos de prueba entre sesiones de trabajo sin instalar un servidor.
  2. Herramienta de escritorio para un usuario único: aplicaciones como un gestor
     personal de inventario o agenda, donde la base de datos es local y no requiere
     concurrencia ni acceso remoto.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 6:
Compara H2 con SQLite: ambas son bases de datos embebidas que no requieren servidor.
¿Cuáles son sus diferencias clave? ¿En qué escenario elegirías una sobre la otra?

RESPUESTA:
H2 y SQLite comparten la característica de no requerir servidor, pero difieren en
varios aspectos fundamentales:

  - Lenguaje: H2 está escrita completamente en Java y se integra de forma nativa
    en aplicaciones JVM. SQLite está escrita en C y requiere un binding JNI para
    usarse desde Java.
  - Compatibilidad SQL: H2 ofrece soporte más cercano al estándar SQL y es
    compatible con la mayoría de sentencias de PostgreSQL, lo que facilita migrar
    entre entornos. SQLite tiene un sistema de tipos más permisivo y algunas
    limitaciones en ALTER TABLE y claves foráneas.
  - Modos de operación: H2 puede funcionar en modo servidor (TCP), permitiendo
    conexiones desde múltiples clientes. SQLite está diseñada para un único proceso
    a la vez; la concurrencia de escritura es muy limitada.
  - Entorno de ejecución: H2 no requiere ninguna instalación nativa; SQLite depende
    de una librería nativa que varía según el sistema operativo.

CUÁNDO ELEGIR CADA UNA:
  - H2 en proyectos Java puros donde se valora la coherencia tecnológica, para
    pruebas automatizadas o para desarrollo local sin instalaciones externas.
  - SQLite para aplicaciones móviles Android/iOS, herramientas de escritorio
    multiplataforma o cualquier contexto donde el archivo .db deba ser portable
    e independiente de la JVM.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 7:
Imagina que el cliente pide migrar la aplicación de H2 a SQL Server en producción.
¿Cuántas líneas del código Java deberías modificar?

RESPUESTA:
Con el patrón DAO implementado correctamente, la migración de H2 a SQL Server
requiere modificar únicamente:

  1. db.properties: cambiar db.engine=h2 por db.engine=sqlserver y añadir las
     credenciales (3 a 5 líneas).
  2. Script SQL: adaptar las diferencias de sintaxis (INT AUTO_INCREMENT → 
     INT IDENTITY(1,1), VARCHAR → NVARCHAR, CURRENT_TIMESTAMP → GETDATE()).
     Esto ocurre solo en el archivo .sql, no en el código Java.
  3. ConexionDB.java: si se usa una implementación propia similar a
     ConnectionFactory, agregar el caso "sqlserver" en el switch (5 a 8 líneas).

En total, el código Java se modifica en menos de 15 líneas. Los DAOs, los Servlets
y las vistas JSP no se tocan en absoluto.

Sin el patrón DAO, habría que localizar y corregir cada consulta SQL embebida en
los Servlets. Con 3 Servlets y al menos 4 operaciones cada uno, la estimación sería
de 50 a 80 líneas de código Java modificadas, distribuidas en múltiples archivos,
con riesgo alto de introducir regresiones.

────────────────────────────────────────────────────────────────────────────────

PREGUNTA 8:
La empresa Ferretería Los Andes de Tunja tiene 200 usuarios concurrentes.
Evaluando los cinco motores del taller, ¿cuál recomendarías y por qué?
¿Qué información adicional necesitarías para decidir?

RESPUESTA:
Con 200 usuarios concurrentes se descarta de inmediato SQLite (concurrencia de
escritura limitada a un proceso) y H2 en modo memoria (datos volátiles). Las
opciones viables son PostgreSQL, SQL Server y Supabase.

RECOMENDACIÓN INICIAL: PostgreSQL.
Es un motor de código abierto con soporte sólido para alta concurrencia, gestión
avanzada de transacciones ACID, y sin costo de licencia. Para 200 usuarios
simultáneos es perfectamente capaz, especialmente combinado con un pool de
conexiones como HikariCP.

INFORMACIÓN ADICIONAL NECESARIA PARA DECIDIR:
  - Infraestructura existente: si la empresa ya tiene servidores Windows con
    licencias Microsoft, SQL Server puede ser más conveniente por coherencia.
  - Presupuesto para licenciamiento: SQL Server Enterprise tiene costo; Express
    tiene limitaciones de RAM y almacenamiento.
  - Ubicación del servidor: si no tienen servidor local confiable, Supabase
    (nube gestionada) reduce la carga de administración.
  - Disponibilidad de DBA: SQL Server tiene herramientas administrativas más
    amigables para personal no especializado en Linux/Unix.
  - Proyección de crecimiento: si esperan superar 500 usuarios, se evaluaría
    solución con réplica o clustering.

────────────────────────────────────────────────────────────────────────────────
SECCIÓN 12.3 – PREGUNTA DE INVESTIGACIÓN
────────────────────────────────────────────────────────────────────────────────

PREGUNTA 9:
¿Qué es un Connection Pool y por qué es esencial en aplicaciones con múltiples
usuarios? Menciona dos librerías Java. ¿H2 soporta connection pooling?
¿Cómo modificarías ConnectionFactory para usar un pool?

RESPUESTA:
Un Connection Pool (pool de conexiones) es un conjunto de conexiones a la base
de datos que se crean al iniciar la aplicación y se reutilizan entre las peticiones
de los usuarios. Abrir una conexión JDBC implica establecer una sesión TCP,
autenticarse y negociar parámetros con el servidor, lo que puede tomar entre 50 y
200 ms. Si cada petición HTTP abre y cierra su propia conexión, el tiempo de espera
se vuelve inaceptable con múltiples usuarios simultáneos.

Con un pool, las conexiones ya están abiertas; una petición simplemente toma una
conexión disponible del pool, la usa y la devuelve al terminar (sin cerrarla
físicamente). Esto reduce el tiempo de acceso a la BD a menos de 1 ms por préstamo.

LIBRERÍAS JAVA QUE IMPLEMENTAN CONNECTION POOLING:
  1. HikariCP: considerada la más rápida y eficiente del ecosistema Java. Es la
     opción por defecto en Spring Boot. Configuración mínima y altísimo rendimiento.
  2. C3P0: librería madura y ampliamente probada, configurable vía XML o código.
     Más verbosa que HikariCP pero con opciones avanzadas de validación de
     conexiones.

H2 SÍ SOPORTA CONNECTION POOLING en modo servidor (TCP). En modo embebido también
puede funcionar con HikariCP configurando correctamente el parámetro
DB_CLOSE_DELAY=-1 para evitar que H2 cierre la BD cuando la última conexión se
devuelve al pool.

MODIFICACIÓN DE ConnectionFactory CON HIKARICP:

  // 1. Agregar dependencia en pom.xml:
  //    <artifactId>HikariCP</artifactId> <version>5.1.0</version>

  // 2. Refactorizar ConnectionFactory:
  import com.zaxxer.hikari.HikariConfig;
  import com.zaxxer.hikari.HikariDataSource;

  public class ConnectionFactory {
      private static final HikariDataSource dataSource;

      static {
          HikariConfig config = new HikariConfig();
          // Leer engine y URL desde db.properties (misma lógica actual)
          config.setJdbcUrl(props.getProperty("sqlserver.url"));
          config.setUsername(props.getProperty("sqlserver.user"));
          config.setPassword(props.getProperty("sqlserver.password"));
          config.setMaximumPoolSize(10);
          config.setConnectionTimeout(5000);
          dataSource = new HikariDataSource(config);
      }

      public static Connection getConnection() throws SQLException {
          return dataSource.getConnection(); // Toma del pool, no abre nueva conexión
      }
  }

  // El resto del código (DAOs, Servlets) no cambia en absoluto.

================================================================================
FIN DEL DOCUMENTO
================================================================================

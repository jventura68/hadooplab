Tenemos que crear una red para los docker a arrancar

    $ docker network create --driver bridge hadoop-net


Después arrancamos los docker indicándole la red a la que conectarse:

    $ docker run -itd --network hadoop-net --name namenode hadooplab bash
    $ docker run -itd --network hadoop-net --name datanode1 hadooplab bash
    
Hecho esto podremos conectar entre los docker por el nombre de máquina
Para conectar desde el host por el nombre de máquina solo tenemos que definir las máquinas
en el fichero /etc/hosts


psedo distribuido

    editar hadoop-env.sh
        export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/

    editar core-site.xml
        <configuration>
            <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
            </property>
            <property>
                <name>hadoop.tmp.dir</name>
                <value>/home/hadoop/hdata</value>
            </property>
        </configuration>
    
    editar hdfs-site.xml
        <configuration>
            <property>
                <name>dfs.replication</name>
                <value>1</value>
            </property>
        </configuration>

    editar mapred-site.xml
        <configuration>
            <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
            </property>
            <property>
                <name>yarn.app.mapreduce.am.env</name>
                <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
            </property>
            <property>
                <name>mapreduce.map.env</name>
                <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
            </property>
            <property>
                <name>mapreduce.reduce.env</name>
                <value>HADOOP_MAPRED_HOME=/usr/local/hadoop</value>
            </property>
        </configuration>
    
    editar yarn-site.xml
        <configuration>
            <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
            </property>
            <property>
                <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
                <value>org.apache.hadoop.mapred.ShuffleHandler</value>
            </property> 
        </configuration>


comprobar ssh
    $ ssh localhost

    si no funciona incluir las sentencias:
        $ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
        $ chmod 0600 ~/.ssh/authorized_keys
        $ sudo sh /etc/init.d/ssh start
        $ ssh localhost
           ---> esto genera la clave para ssh sin pass.
    



    $hdfs namenode -format

    Si da el error "rcmd: socket: Permission denied" es porque el rcdm del pdsh no es ssh, hay que cambiarlo ver https://stackoverflow.com/a/48415037/4021625
        --> No debería dar error porque está añadido en la imagen hadooplab

        $ export PDSH_RCMD_TYPE=ssh

    

    $ start-dfs.sh
    $ start-yarn.sh

    hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount input output



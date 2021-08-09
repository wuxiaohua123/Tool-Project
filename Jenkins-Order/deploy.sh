#### 使用Shell：编译 + 部署Jenkins-Order站点 ####

#!/usr/bin/env bash

# Jenkins任务----需要配置如下参数
# 1.项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export PROJ_PATH=这个jenkins任务在部署机器上的路径
# 2.输入你的环境上tomcat的全路径
# export TOMCAT_APP_PATH=tomcat在部署机器上的路径

# 关闭tomcat函数
killTomcat()
{
    pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      kill -9 $pid
    fi
}

# 构建Maven工程
cd $PROJ_PATH/Jenkins-Order
mvn clean install

# 停止tomcat
killTomcat

# 删除原有工程
rm -rf $TOMCAT_APP_PATH/webapps/ROOT
rm -f $TOMCAT_APP_PATH/webapps/ROOT.war
rm -f $TOMCAT_APP_PATH/webapps/Jenkins-Order.war

# 复制新的工程 部署到 tomcat上
cp $PROJ_PATH/Jenkins-Order/target/Jenkins-Order.war $TOMCAT_APP_PATH/webapps/

# 将新工程 重命名为 ROOT工程,使其运行在tomcat的根目录上
cd $TOMCAT_APP_PATH/webapps/
mv Jenkins-Order.war ROOT.war

# 启动Tomcat
cd $TOMCAT_APP_PATH/
sh bin/startup.sh
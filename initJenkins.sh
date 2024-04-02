docker volume create jenkins_pl_home
docker run -v jenkins_pl_home:/var/jenkins_pl_home -p 8080:8080 --name jenkins_pl --restart=on-failure   jenkins/jenkins:2.414.3-lts-jdk17

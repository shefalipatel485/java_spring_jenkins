pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "java_spring_jenkins:v1.2"
        DOCKERHUB_USER = "gj23aj2901"
        EC2_USER = "ec2-user"
        EC2_HOST = "3.109.3.44"
        EC2_KEY = "C:\\Users\\Shefali\\OneDrive\\Desktop\\Aws_key\\aws.pem"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/shefalipatel485/java_spring_jenkins.git'
            }
        }

       stage('Build with Maven') {
    steps {
        withMaven(maven: 'Maven3') {
            bat 'mvn clean package -DskipTests'
        }
    }
}

       

      stage('Docker Login') {
    steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
        }
    }
}

stage('Build Docker Image') {
    steps {
        bat 'docker build -t %DOCKER_IMAGE% .'
    }
}

stage('Push Docker Image') {
    steps {
        bat 'docker tag %DOCKER_IMAGE% %DOCKER_USER%/%DOCKER_IMAGE%'
        bat 'docker push %DOCKER_USER%/%DOCKER_IMAGE%'
    }
}
        stage('Deploy to EC2') {
            steps {
                bat """
                    ssh -o StrictHostKeyChecking=no -i "%EC2_KEY%" %EC2_USER%@%EC2_HOST% ^
                    "docker pull %DOCKERHUB_USER%/%DOCKER_IMAGE% && ^
                     docker stop app || true && ^
                     docker rm app || true && ^
                     docker run -d --name app -p 8080:8080 %DOCKERHUB_USER%/%DOCKER_IMAGE%"
                """
            }
        }
    }
}

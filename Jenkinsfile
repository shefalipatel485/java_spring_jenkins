pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "java_spring_jenkins"   // local image name without tag
        DOCKER_TAG   = "v1.2"                  // tag
        DOCKER_USER  = "gj23aj2901"            // Docker Hub username
        EC2_USER     = "ec2-user"
        EC2_HOST     = "3.109.3.44"
        EC2_KEY      = "C:\\jenkin_key\\aws.pem"
        MAVEN_HOME   = "Maven3"
        APP_PORT     = "9090"                  // New port for Spring Boot app
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
                withMaven(maven: MAVEN_HOME) {
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
                bat "docker build -t %DOCKER_IMAGE%:%DOCKER_TAG% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat """
                        echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                        docker tag %DOCKER_IMAGE%:%DOCKER_TAG% %DOCKER_USER%/%DOCKER_IMAGE%:%DOCKER_TAG%
                        docker push %DOCKER_USER%/%DOCKER_IMAGE%:%DOCKER_TAG%
                    """
                }
            }
        }

         stage('Deploy to EC2') {
    steps {
        sshagent(['ec2-ssh']) {
            bat """
                ssh -o StrictHostKeyChecking=no %EC2_USER%@%EC2_HOST% ^
                "docker pull %DOCKER_USER%/%DOCKER_IMAGE%:%DOCKER_TAG% && ^
                 (docker stop app 2>nul || exit /b 0) && ^
                 (docker rm app 2>nul || exit /b 0) && ^
                 docker run -d --name app -p %APP_PORT%:%APP_PORT% -e SERVER_PORT=%APP_PORT% %DOCKER_USER%/%DOCKER_IMAGE%:%DOCKER_TAG%"
            """
        }
    }
    }
    }

    post {
        always {
            bat 'docker logout'
        }
    }
}




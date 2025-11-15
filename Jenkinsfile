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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE} .
                """
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                    echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USER}" --password-stdin
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                    docker tag ${DOCKER_IMAGE} ${DOCKERHUB_USER}/${DOCKER_IMAGE}
                    docker push ${DOCKERHUB_USER}/${DOCKER_IMAGE}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                    ssh -o StrictHostKeyChecking=no -i "${EC2_KEY}" ${EC2_USER}@${EC2_HOST} \
                    'docker pull ${DOCKERHUB_USER}/${DOCKER_IMAGE} &&
                     docker stop app || true &&
                     docker rm app || true &&
                     docker run -d --name app -p 8080:8080 ${DOCKERHUB_USER}/${DOCKER_IMAGE}'
                """
            }
        }
    }
}
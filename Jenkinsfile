pipeline {
    agent any
    environment {
        //be sure to replace "DOCKER_IMAGE_NAME" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "dsricharan/train-schedule"
    }
    stages {
        stage("Checkout from github repo"){
            steps{
            # Replace with your github repo
            git url: 'https://github.com/sricharand/cicd-pipeline-train-schedule-autodeploy.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
		    when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
					  app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
        stage('Push Docker Image') {
		  when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            steps {
                kubeconfig(caCertificate: 'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCakNDQWU2Z0F3SUJBZ0lCQVRBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwdGFXNXAKYTNWaVpVTkJNQjRYRFRJME1EUXhPVEV4TlRVeE1sb1hEVE0wTURReE9ERXhOVFV4TWxvd0ZURVRNQkVHQTFVRQpBeE1LYldsdWFXdDFZbVZEUVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTTFzCmZsL1VVZHNwV3BFazhVV2IzVWZJa0EzTjIva1h3M1FtTmlnaFZYckt0T25yRjhXL0h0dUVXU0hZYTdxT0VlVVMKUWF1VU1Lc0M3bWVmRmJOdkNIWjFqcWYxS0d4MUpjT2c4QklqanBmNUxzTDY4em9Zb2hVSU53STg2UGlWRGpoZQpKYklPWkZGdGRUVEZRK2R4ZEpKOXVkaEx1ZmlmTFVUVm5RZzU4QUsvVjViclVUOEdvZ090MGIzU2RIYmo0YVFsCm8yVVdablZzYzFIOXg0SVA2RW1HWkZLYTdiUXZ4N0dIcnBTdWxMbFdZQzdjczdKQU1lTkRTUkoveHQwZ25vNWsKWkNSQ21jbzN2RnBINkNPNUgyTkgvNzBxNlZGb05ZbEZnNGV3TUdVYlAramhaWVdDV2VNVTZPOHZmQkEzUXIzcgpNZ1RrQ3R6YUJubUEwajY5ZllzQ0F3RUFBYU5oTUY4d0RnWURWUjBQQVFIL0JBUURBZ0trTUIwR0ExVWRKUVFXCk1CUUdDQ3NHQVFVRkJ3TUNCZ2dyQmdFRkJRY0RBVEFQQmdOVkhSTUJBZjhFQlRBREFRSC9NQjBHQTFVZERnUVcKQkJSRDhlcW95Q01NMThmcDV5RWFmS3NEUnZHZnFUQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFmVjIvSGlYeAphUnNKK3FBT1RoTm40dytPMndKSUd1WWtkUmZRZlp5K1lJYlRrYWZVV09rbzRnQStTRFVHWGJsdkV3OHJ1RUpWCjZkbkMwd29sOVZsQTc0ajlKa1RNVFpUYlpuRWlPSGRacS9WV1dRb25xNk41cGlrZEhZM2ZGRHEwTmRUdndhNkQKZlpzM2w2MzhWT3FtdXptRlYzTE1LYzA2MVVQdFpmd1lBZVJrSUpLN3UxRU9VOWhWek0wdkw2ZkJGaTJjVWczVQphMjRSZ2xVczZid3lpeFovbTJQb2pjaXdNRzdkMlNqVkZVM2lnbHBOZzN3SDhVQThGODQrOVZmSzlLcWNNc2Y1CkJQbElMdTRFM0tEaTBKZVhQRGJra2c2WmQrQTdoRURTaEJCWUY1ZFExckYxakJuTi9sQkdTbHpZVjhHak1HQTEKK1QrSzlKcFlmMStLWkE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==', credentialsId: 'kubernetes', serverUrl: 'https://192.168.49.2:8443') {
    // some block
                 sh 'kubectl apply -f deployment.yaml'
                 sh 'kubectl apply -f app-service.yaml'
                 sh 'kubectl rollout restart deployment train-schedule'
}
            }
        }
    }
}

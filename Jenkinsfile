pipeline {
    agent any

    environment {
        GIT_TOKEN           = credentials('github-token')

        TF_BACKEND_BUCKET   = "mytestbucket-mangesh"
        TF_REGION           = "ap-south-1"
        TF_BACKEND_KEY      = "terraform.tfstate"
    }

    stages {

        stage('Checkout') {
            steps {
                git url: "https://github.com/DevopsPathshala-ai/CI-CD_Pipeline-Exlearn-B15.git",
                    credentialsId: 'github-token',
                    branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        terraform init \
                          -backend-config="bucket=${TF_BACKEND_BUCKET}" \
                          -backend-config="key=${TF_BACKEND_KEY}" \
                          -backend-config="region=${TF_REGION}" \
                          -backend-config="encrypt=true"
                    '''
                }
            }
        }

        stage('Fmt & Validate') {
            steps {
                sh '''
                    terraform fmt -check
                    terraform validate
                '''
            }
        }

        stage('Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }
            post {
                success {
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }

        stage('Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                        terraform apply -input=false tfplan
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Terraform apply succeeded!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}

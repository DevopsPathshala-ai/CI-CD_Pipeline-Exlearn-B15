pipeline {
    agent any

    environment {
       
        AWS_CREDS           = credentials('aws-creds')
        GIT_TOKEN           = credentials('github-token')

       
        TF_BACKEND_BUCKET   = "mytestbucket-mangesh"
        TF_REGION           = "ap-south-1"
        TF_BACKEND_KEY      = "terraform.tfstate"
    }

    stages {

        stage('Checkout') {
            steps {
                script {
                    git url: "https://github.com/DevopsPathshala-ai/CI-CD_Pipeline-Exlearn-B15.git",
                        credentialsId: 'github-token',
                        branch: 'main'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}
                    export AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}

                    terraform init -input=false \
                      -backend-config="bucket=${TF_BACKEND_BUCKET}" \
                      -backend-config="region=${TF_REGION}" \
                      -backend-config="key=${TF_BACKEND_KEY}" \
                      -backend-config="dynamodb_table=${TF_DDB_TABLE}"
                '''
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
                sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}
                    export AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}

                    terraform plan -input=false \
                        -var-file=environments/dev.tfvars \
                        -out=tfplan
                '''
            }
            post {
                success {
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }

        stage('Apply') {
            steps {
                sh '''
                    export AWS_ACCESS_KEY_ID=${AWS_CREDS_USR}
                    export AWS_SECRET_ACCESS_KEY=${AWS_CREDS_PSW}

                    terraform apply -input=false tfplan
                '''
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

@Library('my-shared-library') _

//def myUtils = library 'my-shared-library@main'

pipeline {

  agent any
  
  parameters {
	choice(name: 'action', choices: 'create\nrollback', description: 'Create/rollback of the deployment')
    //string(name: 'ImageName', description: "Name of the docker build")
	//string(name: 'ImageTag', description: "Name of the docker build")
	//string(name: 'AppName', description: "Name of the Application")
   //string(name: 'docker_repo', description: "Name of docker repository")
  }
      
    stages {
        stage('Git Checkout') {
            when {
				expression { params.action == 'create' }
			}
            steps {
                gitCheckout(
                    branch: "main",
                    url: "https://github.com/vikash-kumar01/springboot_k8s_application.git"
                )
            }
        }
        stage('Unit Test Maven'){
            when {
				expression { params.action == 'create' }
            }
    	   steps{
    	    script{
        		mvnTest()
    	    }
    		  }
	    }
 	    stage('Maven Integration test'){
            when {
				expression { params.action == 'create' } 			}

     		steps {
     	script{
         		 integrationTest()
     		}
 			}
	    }
        stage('Static code analysis') {
            when {
                expression { params.action == 'create' }
            }
            steps {
                script {
                    def sonarCredentialId = 'sonar-api'
                    StaticCodeAnalysis(sonarCredentialId)
                }
            }
        }
        stage('Quality Gate Status') {
                        when {
 				expression { params.action == 'create' }
 				}
            steps {
                script{
                    def sonarCredentialId = 'sonar-api'
                    QualityGateStatus(sonarCredentialId)
                }
            }
        }
		stage('Build Maven'){
            when {
 				expression { params.action == 'create' }
 				}
     		steps {
     	script{
         		mvnBuild()
     		}
			} 	    
        }
		tage('Build Dockerfile') {
            steps {
                script {
                    // Define the path to the jar file in the Jenkins workspace
                    def jarFilePath = "${env.WORKSPACE}/shared_lib_application/target/*.jar"

		            // Set the Docker build argument to the jar file path
                    def dockerBuildArgs = "--build-arg JAR_FILE=${jarFilePath}"

                    // Build the Docker image using the `docker` CLI and pass the build argument
                    sh "docker build ${dockerBuildArgs} -t my-image ."

                }
            }
        }
    }
}
# Objective
Deploy a python flask web application using a Jenkins agent through SSH on AWS infrastructure proivisioned using terraform

# Steps
1. Using terraform create your infrastructure for the following resources
- 1 Virtual Private Cloud
- 2 Availability Zones
- 2 Public Subnets
- 3 EC2s
- 1 Route Table
2. Install Jenkins on one of the servers as well as:
- software-properties-common, sudo add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv
- `Pipeline Keep Running Step` Jenkins Plugin
3. On the other 2 servers install:
- default-jre, software-properties-common, sudo add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv
4. Create a jenkins agent on the other instances
5. Create a multibranch pipeline on Jenkins and run it
![Pipeline](screenshots/Screenshot%202023-10-19%20at%204.25.08%20PM.png)
6. The application should be running on port 8000 on the server that the agent was installed on
![Server01](screenshots/Screenshot%202023-10-19%20at%204.24.37%20PM.png)

7. To get the application running on the 2nd application server you have to add a second agent and modify the Jenkinsfile to deploy the app on the server with that agent label
![Server01](screenshots/Screenshot%202023-10-19%20at%204.24.50%20PM.png)

# System Diagram

![Server01](screenshots/Screenshot%202023-10-20%20at%201.39.40%20PM.png)

# Optimization
To optimize this application the two application servers should be placed in their own private subnets for an added layer of security since a private subnet does not have a direct route to an internet gateway. The applications in a private subnet can use a NAT Gateway if it requires access the public internet. Since we have two applications in different Availability zones, using a load balancer can be added to route user traffic as it increases the fault tolerance of your application since traffic is only routed to healthy instances. Using a Jenkins agent is also recommened for security puposes as any builds running on the built-in node have the same level of access to the controller file system as the Jenkins process. Thus it is recommended to use agents that will communicate with the controller only for the information it needs and if you want another added layer of security for the agents, you would enable the Controller Access Control system on the agent which prevents agent processes from being able to send malicious commands to the Jenkins controller.


# Issues
I ran into an issue on my agent that said the `java` command was not found. I resolved this by running `sudo apt install default-jre`

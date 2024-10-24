resource "aws_instance" "workshop_instance" {
  count         = var.participant_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.workshop_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  root_block_device {
    volume_size = 15  # Change this to the desired size (in GB)
    volume_type = "gp2"  # General Purpose SSD, can use gp3 for cost optimization
  }

  tags = {
    Name = "Workshop-Participant-${count.index + 1}"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update packages
              sudo apt-get update -y

              # Install Java (required for Jenkins)
              sudo apt-get install openjdk-11-jdk -y

              # Add Jenkins repository and install Jenkins
              wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt-get update -y
              sudo apt-get install jenkins -y

              # Start Jenkins
              sudo systemctl start jenkins

              # Enable Jenkins to start at boot
              sudo systemctl enable jenkins

              # Ensure Jenkins is running
              sudo systemctl status jenkins

              # Install Python
              sudo apt-get install python3 -y
              sudo apt-get install python3-pip -y

              # Install Docker
              sudo apt-get install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker

              # Add the 'ubuntu' user to the 'docker' group to avoid needing sudo
              sudo usermod -aG docker ubuntu

              # Print versions of Jenkins, Python, and Docker for confirmation
              java -version
              python3 --version
              docker --version
              EOF
}

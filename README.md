# SRAssesment


Within docker directory, run the below commands to bring up docker container 

### To build the docker image - 
```bash
    docker-compose build
```

### To bring up docker-compose service 
```bash
docker-compose up -d
```


===============================
Terraform itself calls Ansible to run playbook on provsioned ec2 instance. 
To provision EC2 instance with ansible, 
got to terraform diretorty 
```bash
cd terraform
```

* Initialize directory 
```bash
terraform init
```

* Prepare execution plan
```bash
terraform plan
```

* implement the changes 
```bash
terraform apply
```


==================================
To run Ansible separately from ansible directory
```bash
cd ansible
```

* update host.inventory file with publicip of ec2 instance 

* run ansible to provison the changes 

```bash
ansible-playbook -u root -i host.inventory nginx_install.yml
```
# 1. Criar a VPC (Rede isolada)
resource "aws_vpc" "vpc_projeto2" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-projeto-persistencia"
  }
}

# 2. Criar a Subnet Pública dentro da VPC
resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.vpc_projeto2.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-publica-projeto2"
  }
}

# 3. Criar o Internet Gateway para dar acesso à Internet para a VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_projeto2.id

  tags = {
    Name = "igw-projeto2"
  }
}

# 4. Criar a Tabela de Rotas e direcionar o tráfego para o Internet Gateway
resource "aws_route_table" "rt_publica" {
  vpc_id = aws_vpc.vpc_projeto2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-publica-projeto2"
  }
}

# 5. Associar a Subnet à Tabela de Rotas Pública
resource "aws_route_table_association" "associacao_publica" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.rt_publica.id
}

# 6. Grupo de Segurança (Firewall) consumindo sua variável de IP seguro
resource "aws_security_group" "sg_projeto2" {
  name        = "sg_projeto2"
  description = "Permite SSH seguro e HTTP"
  vpc_id      = aws_vpc.vpc_projeto2.id

  ingress {
    description = "SSH Seguro"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.meu_ip_seguro] # Consumindo a variável do variables.tf!
  }

  ingress {
    description = "HTTP para o Mundo"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-projeto2"
  }
}

# 7. Criar a Instância EC2 com Script de Automação (Sem chaves SSH)
resource "aws_instance" "servidor_projeto2" {
  ami                    = "ami-04b70fa74e45c3917" # Ubuntu Server 24.04 LTS
  instance_type          = var.tipo_instancia     
  subnet_id              = aws_subnet.subnet_publica.id
  vpc_security_group_ids = [aws_security_group.sg_projeto2.id]

 # O script definitivo com o seu perfil profissional real
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              
              # Criando a Landing Page oficial do Yghor
              cat << 'HTML' > /var/www/html/index.html
              <!DOCTYPE html>
              <html lang="pt-BR">
              <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Yghor | DevOps & Cloud Portfolio</title>
                  <style>
                      body {
                          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                          background-color: #0f172a;
                          color: #f8fafc;
                          display: flex;
                          justify-content: center;
                          align-items: center;
                          min-height: 100vh;
                          margin: 0;
                          padding: 20px;
                      }
                      .container {
                          background-color: #1e293b;
                          padding: 40px;
                          border-radius: 12px;
                          box-shadow: 0 10px 25px rgba(0,0,0,0.3);
                          max-width: 650px;
                          width: 100%;
                          border-top: 5px solid #3b82f6;
                      }
                      h1 {
                          color: #3b82f6;
                          margin-top: 0;
                          font-size: 2rem;
                      }
                      h2 {
                          color: #60a5fa;
                          font-size: 1.2rem;
                          margin-top: 25px;
                          margin-bottom: 10px;
                          border-bottom: 1px solid #334155;
                          padding-bottom: 5px;
                      }
                      p {
                          line-height: 1.6;
                          color: #cbd5e1;
                          font-size: 1.05rem;
                          margin-bottom: 15px;
                      }
                      ul {
                          margin-top: 5px;
                          padding-left: 20px;
                          color: #cbd5e1;
                          line-height: 1.6;
                      }
                      .badge {
                          background-color: #1e3a8a;
                          color: #60a5fa;
                          padding: 4px 10px;
                          border-radius: 6px;
                          font-size: 0.85rem;
                          font-weight: bold;
                          display: inline-block;
                          margin-bottom: 15px;
                      }
                      .btn-linkedin {
                          display: inline-block;
                          background-color: #0077b5;
                          color: white;
                          text-decoration: none;
                          padding: 12px 24px;
                          border-radius: 6px;
                          font-weight: bold;
                          margin-top: 25px;
                          text-align: center;
                          transition: background-color 0.2s;
                      }
                      .btn-linkedin:hover {
                          background-color: #005582;
                      }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <div class="badge">Projeto 2 - Infraestrutura como Código (IaC) 🚀</div>
                      <h1>Olá, eu sou o Yghor! 👋🏼🇧🇷</h1>
                      
                      <h2>💼 Momento Atual</h2>
                      <p>Atuo como <strong>Analista de TI</strong> focado no suporte técnico de infraestrutura e na sustentação de sistemas ERP. Tenho experiência abrangendo parametrização fiscal, regras de negócio e conectividade, sendo proficiente no fluxo completo de documentos fiscais eletrônicos (NF-e, NFC-e) e na validação de rejeições junto à base da SEFAZ.</p>
                      
                      <h2>📚 Estudos & Foco</h2>
                      <p>Atualmente cursando o 1º semestre de <strong>Redes de Computadores</strong> e aluno na residência em TIC ofertada pelo <strong>Capacita iRede</strong>, na trilha de <strong>Cloud (PSC)</strong>, meu principal foco de especialização na carreira.</p>
                      <p>Buscando aprimoramento contínuo para o mercado global, também curso o 3º semestre de <strong>Inglês</strong> no centro de línguas da cidade em que resido.</p>
                      
                      <h2>🎯 Objetivo para o Ano</h2>
                      <p>Meu grande compromisso é entregar projetos de IaC dinâmicos, crescentes e constantes para expandir minha bagagem técnica em Cloud Computing, arquiteturas escaláveis e automação.</p>
                      <p>Profissionalmente, meu objetivo no segundo semestre é conquistar uma posição como Cloud Engineer Júnior.<p>

                      <a href="https://www.linkedin.com/in/yghoralexandre/" target="_blank" class="btn-linkedin">Conecte-se comigo no LinkedIn 💼</a>
                  </div>
              </body>
              </html>
              HTML

              systemctl enable nginx
              systemctl start nginx
              EOF
}

# 8. Criar o Disco Extra (EBS Volume) na mesma Zona de Disponibilidade da EC2
resource "aws_ebs_volume" "disco_extra" {
  availability_zone = aws_instance.servidor_projeto2.availability_zone
  size              = var.tamanho_disco_ebs # Consumindo a variável de 10GB!

  tags = {
    Name = "Disco-Extra-10GB"
  }
}

# 9. O "Ato Final": Acoplar o disco criado dentro da instância EC2
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.disco_extra.id
  instance_id = aws_instance.servidor_projeto2.id
}
variable "regiao_aws" {
  description = "Região padrão do provisionamento"
  type        = string
  default     = "us-east-1"
}

variable "tipo_instancia" {
  description = "Tamanho da máquina virtual para o Free Tier"
  type        = string
  default     = "t3.micro"
}

variable "tamanho_disco_ebs" {
  description = "Tamanho do disco extra em Gigabytes"
  type        = number
  default     = 10
}

variable "meu_ip_seguro" {
  description = "Seu IP residencial com o sufixo /32 para trancar o SSH"
  type        = string
  default     = "192.168.1.4/32" # Lembre-se de colocar seu IP real/32 aqui quando for testar!
}
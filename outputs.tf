# 1. Mostrar o IP Público do Servidor
output "ip_publico_servidor" {
  description = "IP público da instância EC2 para o acesso SSH"
  value       = aws_instance.servidor_projeto2.public_ip
}

# 2. Mostrar o ID do Volume EBS criado
output "id_disco_extra" {
  description = "ID do volume EBS de 10GB que foi acoplado"
  value       = aws_ebs_volume.disco_extra.id
}

# 3. Mostrar o status do acoplamento do disco
output "status_acoplamento_disco" {
  description = "O estado atual do acoplamento do volume EBS na instância"
  value       = aws_volume_attachment.ebs_att.id
}
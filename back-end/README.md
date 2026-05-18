# MedControl Backup Backend

Backend API para backup dos dados do aplicativo MedControl, desenvolvido com FastAPI.

## Funcionalidades

- Criar backups dos dados dos pacientes
- Listar backups existentes
- Recuperar dados de backup específicos
- Deletar backups antigos
- Health check da API

## Estrutura dos Dados

Os backups incluem:
- Informações do paciente (ID, nome, idade)
- Medicamentos cadastrados
- Agendamentos
- Histórico de uso
- Configurações do aplicativo

## Endpoints da API

### POST /backups
Cria um novo backup.

**Request Body:**
```json
{
  "patient_id": "string",
  "patient_name": "string",
  "patient_age": 25,
  "medications": [...],
  "schedules": [...],
  "history": [...],
  "settings": {...}
}
```

**Response:**
```json
{
  "id": "uuid",
  "patient_id": "string",
  "patient_name": "string",
  "created_at": "2024-01-01T12:00:00",
  "size_bytes": 1024
}
```

### GET /backups
Lista todos os backups, opcionalmente filtrados por patient_id.

**Query Parameters:**
- `patient_id` (opcional): Filtrar por ID do paciente

**Response:**
```json
[
  {
    "id": "uuid",
    "patient_id": "string",
    "patient_name": "string",
    "created_at": "2024-01-01T12:00:00",
    "size_bytes": 1024
  }
]
```

### GET /backups/{backup_id}
Recupera os dados completos de um backup específico.

### DELETE /backups/{backup_id}
Deleta um backup específico.

### GET /health
Verifica se a API está funcionando.

## Como Executar

1. Instalar dependências:
```bash
pip install -r requirements.txt
```

2. Executar o servidor:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

3. A API estará disponível em: http://localhost:8000

4. Documentação automática: http://localhost:8000/docs

## Armazenamento

Os backups são salvos como arquivos JSON no diretório `storage/backups/`.

## Integração com o Frontend

O frontend Flutter pode usar os endpoints da API para:
- Enviar dados para backup via POST /backups
- Listar backups disponíveis via GET /backups
- Baixar dados para restauração via GET /backups/{id}
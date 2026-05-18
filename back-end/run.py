#!/usr/bin/env python3
"""
Script para executar o servidor de backup do MedControl
"""

import uvicorn
import os
import sys

# Adicionar o diretório app ao path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'app'))

if __name__ == "__main__":
    print("🚀 Iniciando servidor de backup do MedControl...")
    print("📁 Backups serão salvos em: storage/backups/")
    print("🌐 API disponível em: http://localhost:8000")
    print("📚 Documentação: http://localhost:8000/docs")
    print()

    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
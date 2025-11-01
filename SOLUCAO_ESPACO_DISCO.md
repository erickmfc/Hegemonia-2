# 🔴 SOLUÇÃO: Espaço Insuficiente no Disco

## ❌ PROBLEMA IDENTIFICADO

O disco **C:** está **100% cheio** (0 bytes livres). Isso impede a compilação do GameMaker.

## ✅ SOLUÇÕES IMEDIATAS

### **1. Limpar Cache do GameMaker (RECOMENDADO)**

Execute o arquivo `limpar_cache_gamemaker.bat` que foi criado na raiz do projeto.

**OU manualmente:**

1. Feche o GameMaker Studio 2
2. Abra o Explorador de Arquivos
3. Vá para: `C:\Users\Mathe\AppData\Local\GameMakerStudio2\GMS2TEMP`
4. Delete **TUDO** dentro dessa pasta
5. Vá para: `C:\Users\Mathe\AppData\Roaming\GameMakerStudio2\Cache`
6. Delete **TUDO** dentro dessa pasta
7. Reabra o GameMaker

### **2. Limpar Arquivos Temporários do Windows**

1. Pressione `Win + R`
2. Digite: `%TEMP%`
3. Delete todos os arquivos possíveis
4. Pressione `Win + R` novamente
5. Digite: `temp`
6. Delete todos os arquivos possíveis

### **3. Usar Limpeza de Disco do Windows**

1. Pressione `Win + X`
2. Escolha "Gerenciador de Disco"
3. Ou use "Limpeza de Disco" (Disk Cleanup)
4. Selecione todos os itens e execute

### **4. Mover Projeto para Outro Disco (LONGO PRAZO)**

Se possível, considere mover o projeto para o disco **E:** que tem **229 GB livres**:

1. Copie a pasta do projeto para `E:\Hegemonia Global\teste\Hegemonia-2`
2. Abra o projeto de lá

## 📊 SITUAÇÃO ATUAL DOS DISCOS

- **Disco C:** 0 GB livres ❌ (CRÍTICO)
- **Disco D:** 15.33 GB livres ⚠️
- **Disco E:** 229.62 GB livres ✅

## 🎯 PRÓXIMOS PASSOS

1. Execute `limpar_cache_gamemaker.bat`
2. Tente compilar novamente
3. Se ainda não funcionar, libere mais espaço no disco C:


# 🚨 REGRAS CRÍTICAS DE SINTAXE JSON

## ❌ NUNCA FAÇA ISSO (Vírgulas Extras)

### Erro Comum 1: Vírgula antes de fechamento de objeto
```json
{
  "campo1": "valor1",
  "campo2": "valor2",  ← ❌ VÍRGULA EXTRA!
}
```

### Erro Comum 2: Vírgula antes de fechamento de array
```json
[
  "item1",
  "item2",  ← ❌ VÍRGULA EXTRA!
]
```

### Erro Comum 3: Vírgula em último item de objeto dentro de array
```json
[
  {
    "nome": "João",
    "idade": 30,  ← ❌ VÍRGULA EXTRA!
  }
]
```

## ✅ SEMPRE FAÇA ASSIM (Sintaxe Correta)

### Correto 1: Sem vírgula no último item de objeto
```json
{
  "campo1": "valor1",
  "campo2": "valor2"  ← ✅ SEM VÍRGULA!
}
```

### Correto 2: Sem vírgula no último item de array
```json
[
  "item1",
  "item2"  ← ✅ SEM VÍRGULA!
]
```

### Correto 3: Sem vírgula no último item de objeto dentro de array
```json
[
  {
    "nome": "João",
    "idade": 30  ← ✅ SEM VÍRGULA!
  }
]
```

## 🔧 COMO CORRIGIR AUTOMATICAMENTE

Execute o script PowerShell:
```powershell
.\fix_json_syntax.ps1
```

## 📋 CHECKLIST ANTES DE SALVAR

- [ ] Verificar se não há vírgulas antes de `}`
- [ ] Verificar se não há vírgulas antes de `]`
- [ ] Verificar se o último item de objetos/arrays não tem vírgula
- [ ] Testar se o JSON é válido usando um validador online

## 🎯 LEMBRE-SE

**UMA VÍRGULA EXTRA PODE QUEBRAR TODO O ARQUIVO JSON!**

O GameMaker Studio é muito rigoroso com a sintaxe JSON. Sempre verifique antes de salvar.

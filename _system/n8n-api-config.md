# n8n API Configuration

## API Key (JWT)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiMDNmMzgyZC03ODExLTQ3YjMtODFhYS01NWFkOThjMTUxNGMiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwianRpIjoiZTczYWM4ZWUtODY4ZC00YmQ2LWIyZTMtMGZmYWFiYzcwZTE4IiwiaWF0IjoxNzcxMTA1ODEwLCJleHAiOjE3Nzg4MTc2MDB9.MEpoMwue-YZUQwCBkL4HBX2p4I_HSW4dRXmCZ0HZSDA
```

## ngrok URL
```
https://unoxidated-ian-nonrepressibly.ngrok-free.dev
```

## Webhook URL
```
https://unoxidated-ian-nonrepressibly.ngrok-free.dev/webhook/jack-notify
```

## API Endpoints (when workflow active)
```
GET  /rest/workflows          # List workflows
GET  /rest/workflows/:id      # Get workflow
POST /rest/workflows/:id/execute  # Execute workflow
```

## Status
- [x] ngrok configured
- [x] API key received
- [ ] Workflow activation pending (waiting for John)

## Notes
API returns 400 currently because workflow is not active.
Once John activates the workflow, webhooks will work.

Last updated: 2026-02-15

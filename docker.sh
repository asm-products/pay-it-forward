#!/bin/bash
export DATABASE_URL=postgres://postgres:@$(boot2docker ip 2>/dev/null):5432/payitforward
export REDIS_URL=redis://$(boot2docker ip 2>/dev/null):6379

fig build postgres redis
fig up -d postgres redis

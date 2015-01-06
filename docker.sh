#!/bin/bash
export DATABASE_URL=postgres://postgres:@$(boot2docker ip 2>/dev/null):5432/payitforward

fig build postgres
fig up -d postgres

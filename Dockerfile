FROM swift:latest

WORKDIR /app

COPY main.swift /app/main.swift

CMD ["swift", "main.swift"]


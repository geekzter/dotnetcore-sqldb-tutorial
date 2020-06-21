# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build

# Copy source and build app (this will also perform a restore)
WORKDIR /source
COPY . .
RUN dotnet publish -c release -o /app 

# Final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
#ENV ASPNETCORE_URLS https://+:443;http://+:80
COPY --from=build /app ./
COPY --from=build /source/localdatabase.db  ./
#ENTRYPOINT ["dotnet", "DotNetCoreSqlDb.dll"]
ENTRYPOINT ["dotnet", "DotNetCoreSqlDb.dll","--urls 'https://+:443;http://+:80'"]
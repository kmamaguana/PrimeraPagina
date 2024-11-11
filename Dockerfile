FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["PrimeraPagina/PrimeraPagina.csproj", "PrimeraPagina/"]
RUN dotnet restore "PrimeraPagina/PrimeraPagina.csproj"
COPY . . 
WORKDIR "/src/PrimeraPagina"
RUN dotnet build "PrimeraPagina.csproj" -c $BUILD_CONFIGURATION -o /app/build
FROM build AS publish
RUN dotnet publish "PrimeraPagina.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish . 
ENTRYPOINT ["dotnet", "PrimeraPagina.dll"]

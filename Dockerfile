FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["JenkinsAndAnsible/JenkinsAndAnsible.csproj", "JenkinsAndAnsible/"]
RUN dotnet restore "JenkinsAndAnsible/JenkinsAndAnsible.csproj"
COPY . .
WORKDIR "/src/JenkinsAndAnsible"
RUN dotnet build "JenkinsAndAnsible.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkinsAndAnsible.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkinsAndAnsible.dll"]

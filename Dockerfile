#Stage 1: Define base image which will be used as base
FROM  mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
EXPOSE 80
WORKDIR /app

#Stage 2: Copy csproj and restore as distinct layers
COPY sajidwebapp/*.csproj .
RUN dotnet restore

#Stage 3: Copy everything else and build
COPY sajidwebapp/. .
RUN dotnet publish -c release -o /webapp --no-restore

#Stage 4: Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1 
WORKDIR /webapp
COPY --from=build-env /webapp ./
ENTRYPOINT ["dotnet","sajidwebapp.dll"]


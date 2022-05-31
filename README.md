# Prerequisitos:

- Acesso a uma conta de trial na Oracle Cloud Infrastructure
- Crie uma nova Virtual Cloud Network utilizando a documentação [https://docs.oracle.com/pt-br/iaas/Content/GSG/Tasks/creatingnetwork.htm#Creating_a_Virtual_Cloud_Network](https://docs.oracle.com/pt-br/iaas/Content/GSG/Tasks/creatingnetwork.htm#Creating_a_Virtual_Cloud_Network)
- Verifique se nas configurações da Virtual Cloud Network, em Listas de Segurança, se as portas 22/TCP, e 8080/TCP estão presentes nas regras de Ingresso (Ingress), senão adicione a regra que está faltando usando o template abaixo:
   - Tipo: Ingress
   - CIDR: 0.0.0.0/0
   - Protocolo: TCP
   - Target (Destino): 8080,22
- Crie uma instância utilizando a _Guia de Imagens Oracle_ tendo como imagem a  Oracle Cloud Developer Image [https://docs.oracle.com/pt-br/iaas/oracle-linux/getting-started/index.htm#](https://docs.oracle.com/pt-br/iaas/oracle-linux/getting-started/index.htm#).
    - A Instância deve ser provisionada na subnet publica!
    - Não se esqueça de salvar o par de chaves gerado pelo formulario de criação
- Acesse a instancia utilizando o cloud shell:
   - Abra o cloud shell na barra superior no direito da console
   - Aguarde o terminal iniciar, clique e arraste os arquivos de chave gerados
   - Utilize o comando abaixo para acessar a instancia via SSH substituindo as informações de IP Publico, e Chave privada:
     ```shell
        ssh -i <chave-privada> opc@<IP-Publico> 
     ```
    - Ao acessar a instância adicione a porta 8080/TCP a regra de firewall
      ```shell
        sudo firewall-cmd --zone=public --permanent --add-port=5000/tcp
        sudo firewall-cmd --reload
       ```
    - Instale o recurso de native image da GraalVM:
       ```shell
        gu install native-image
       ```



# Spring Boot Native Image Microservice Demo

## Overview

Essa demo mostra como você pode construir um simples microsserviço utilizando Spring Boot compilado a partir da GraalVM Native Image. O recurso de native image compila o código java como um executavel nativo do sistema, isso reduz drasticamente o tempo de startup da aplicação, e reduz também o consumo de recursos como tamanho (de imagens de containers), e de memória visto que a build final gera um executavel que não depende da JVM.

Para esse guide você vai usar: [GraalVM](https://www.graalvm.org), o projeto [Spring Native](https://docs.spring.io/spring-native/docs/current/reference/htmlsingle/)(Experimental) e o recurso [GraalVM Native Build Tools](https://github.com/graalvm/native-build-tools).

O microsserviço dessa demo gera frases aleatórias baseadas no estilo do poema Jabberwocky (por Lewis Carrol). Para executar essa feature nosso microsserviço utiliza uma [cadeia de Markov](https://pt.wikipedia.org/wiki/Cadeias_de_Markov) para modelar o texto do poema original e randomizar frases que pareçam ser como as originais. (É importante darmos um pouquinho de trabalho para o microsserviço)

## Building & Running the Java Application

Esse projeto utiliza Maven. Para nossa primeira etapa, compilaremos da forma tradicional onde geraremos o arquivo `jar`:

```shell
mvn clean package
```

isso também construirá uma imagem Docker contendo o arquivo `jar` gerado. A imagem esta sendo executada usando o GraalVM Enterprise Edition como JVM, o que por si só já traz ganho de performance visto que a Graal tem um footprint menor, e formas mais otimizadas para acessar recursos. 

**Quick Note: O GraalVM possui sua versão Community, e sua versão Enterprise com suporte. Em Oracle Cloud, em todos os serviços onde você possui acesso, de alguma forma, ao sistema operacional (Containers, Functions, Instancias...), você tem direito a versão Enterprise do GraalVM e ao Java SE! (Yaaay!!)**

Continuando execute:

```shell
java -jar ./target/benchmark-jibber-0.0.1-SNAPSHOT.jar &
# Aguarde um tempinho até a JVM iniciar
sleep 4
# Chame o endpoint
curl http://localhost:8080/jibber
# Traga o processo de volta, e finalize-o (CTRL+C)
fg
```

Para rodar como um container Docker execute: (A imagem foi gerada pelo processo do Maven)

```shell
docker run --rm --name graalce -d -p 8080:8080 jibber-benchmark:graalee.0.0.1-SNAPSHOT
```
Você pode testar a aplicação da mesma forma usando `curl` -  Lembre-se de esperar um tempinho até a aplicação estar no ar.

## Building & Running the GraalVm Native Image Executable

Agora vamos construir nossa aplicação como um executavel nativo. Esse processo também vai gerar uma nova Docker Image.

Execute:

```shell
# A propriedade -Dnative  é usada para "ativar" o processo de build nativo que está dentro do arquivo do maven
mvn package -Dnative
```

Esse processo gerará um novo binário presente em `target/jibber`. Agora você pode executa-lo como uma aplicação nativa do Linux:

```shell
./target/jibber &
curl http://localhost:8080/jibber
fg
```

Pelo log do executavel é possivel notar que a aplicação inicia muito mais rapido do que a versão anterior empacotada em `jar`.

## Containerizando o Executavel Nativo

Execute os seguintes comandos:

```shell
docker build -f Dockerfiles/Dockerfile.native --build-arg APP_FILE=target/jibber -t jibber-benchmark:native.0.0.1-SNAPSHOT
```
Assim que iniciado você pode executar o container usando:

```shell
docker run --rm --name native -d -p 8080:8080 jibber-benchmark:native.0.0.1-SNAPSHOT
```


Essa demo foi baseada na demo presente no repositório de demos da GraalVM.

Existem mais projetos que já sairam de fase experimental, que também fazem uso do recurso de compilação nativa da GraalVM que valem a pena você dar uma olhada:

- [Helidon](https://helidon.io/)
- [Quarkus](https://quarkus.io/) (Ele também possui um initializer similar ao Spring [https://code.quarkus.io/](https://code.quarkus.io/))
- [Micronaut](https://micronaut.io/) (Também possui um initializer [https://micronaut.io/launch](https://micronaut.io/launch))
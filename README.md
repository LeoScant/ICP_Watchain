# Watchain

Welcome to your new Watchain project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

To get started, you might want to explore the project directory structure and the default configuration file. Working with this project in your development environment will not affect any production deployment or identity tokens.

To learn more before you start working with Watchain, see the following documentation available online:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/quickstart/hello10mins)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/build/install-upgrade-remove)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/motoko/)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/references/motoko-ref/)
- [JavaScript API Reference](https://erxue-5aaaa-aaaab-qaagq-cai.raw.icp0.io)

If you want to start working on your project right away, you might want to try the following commands:

```bash
cd Watchain/
dfx help
dfx canister --help
```

## Running the project locally

If you want to test your project locally, you can use the following commands:

```bash
# Starts the replica, running in the background
dfx start --background

# Deploys your canisters to the replica and generates your candid interface
dfx deploy
```

Once the job completes, your application will be available at `http://localhost:4943?canisterId={asset_canister_id}`.

If you have made changes to your backend canister, you can generate a new candid interface with

```bash
npm run generate
```

at any time. This is recommended before starting the frontend development server, and will be run automatically any time you run `dfx deploy`.

To deploy the smartContract on the local network run

```bash
dfx deploy Watchain
```

## Mint an Certificate

To mint a test Certificate run

```bash
dfx canister call Watchain mintCertificate \
"(
  principal\"$(dfx identity get-principal)\", 
  record {
    certificateCardId = \"123aaa\";
    watchBrand = \"Rolex\";
    watchModel = \"Daytona\";
    watchYear = \"2020\";
    jsonData = record {
      id= \"123\";
      createdAt= \"2020-03\";
      inspectionDate= \"2020-03\";
      updatedAt= \"2020-03\";
      watchBrand= \"Rolex\";
      watchModel= \"Daytona\";
      generalCondition= \"Good\";
      watchYearOrDecade= \"2020\"
    }
  }
)"
```

## Get a Certificate

To see the certificate run

```bash
dfx canister call Watchain getCertificateFromTokenId "(0)"
```

## Update a Certificate

To update the certificate data run this, changing the data as you prefere

```bash
dfx canister call Watchain updateCertificate "(
  0, 
  principal\"$(dfx identity get-principal)\", record {
      certificateCardId = \"456aaa\";
      watchBrand = \"Cartier\";
      watchModel = \"Tank Française\";
      watchYear = \"2021\";
      jsonData = record {
        id= \"aaa\";
        createdAt= \"2020-03\";
        inspectionDate= \"2020-03\";
        updatedAt= \"2020-03\";
        certifierAddress=\"$(dfx identity get-principal)\";
        validatorAddress=\"$(dfx identity get-principal)\";
        watchBrand= \"Rolex\";
        watchModel= \"Daytona\";
        generalCondition= \"Good\";
        watchYearOrDecade= \"2020\"
    };
  }
)"
```

## Transfering a Certificate

First, create a different identity using DFX. This will become the principal that you receives the NFT

```
dfx identity new --disable-encryption alice
ALICE=$(dfx --identity alice identity get-principal)
```

Verify the identity for `ALICE` was created and set as an environment variable:
```
echo $ALICE
```

You should see a principal get printed
```
o4f3h-cbpnm-4hnl7-pejut-c4vii-a5u5u-bk2va-e72lb-edvgw-z4wuq-5qe
```

Transfer the Certificate from the default user to `ALICE`. 

```
dfx canister call Watchain safeTransferCertificate "(principal\"$(dfx identity get-principal)\", principal\"$ALICE\", 0)"
```
# Hello Web3://

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

## Upload Website

### 1. Build Website
Build the website and generate the `dist` folder.
```
npm run build
```

### 2. Faucet
You can obtain the Gas Token via the following [link](https://qkc-l2-faucet.eth.sep.w3link.io/).

### 3. Install ethfs-cli
Install the upload tool `ethfs-cli`.
```
npm install -g ethfs-cli
```

### 4. Create FlatDirectory
Create a FlatDirectory contract.
```
ethfs-cli create -p 0x20cc... -c 43069
```

### 5. Upload Files
Upload the `dist` to the FlatDirectory contract.
```
ethfs-cli upload -a 0xedD...049F -p 0x20cc.. -f dist -c 43069 -t 2
```

### 6. Set Default File.
Set the default file for the FlatDirectory.
```
ethfs-cli default -a 0xedD...049F -p 0x20cc... -f index.html -c 43069
```

### 7. Access the website through gateway.
[https://0xedDC3d17a23eD3e1DeBfF90534eB54532755049F.3336.w3link.io/](https://0xedDC3d17a23eD3e1DeBfF90534eB54532755049F.3336.w3link.io/)

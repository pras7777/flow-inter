// Import necessary contracts and libraries
import FungibleToken from 0x05
import Token from 0x05
import PrasToken from 0x05

transaction(senderAccount: Address, amount: UFix64) {
    let senderVault: &PrasToken.Vault{PrasToken.CollectionPublic}
    let signerVault: &PrasToken.Vault
    let senderFlowVault: &Token.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}
    let adminResource: &PrasToken.Admin
    let flowMinter: &Token.Minter
    prepare(acct: AuthAccount) {
        
        self.adminResource = acct.borrow<&PrasToken.Admin>(from: /storage/AdminStorage)
            ?? panic("Admin Resource is not present")
        self.signerVault = acct.borrow<&PrasToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault not found in signerAccount")
        self.senderVault = getAccount(senderAccount)
            .getCapability(/public/Vault)
            .borrow<&PrasToken.Vault{PrasToken.CollectionPublic}>()
            ?? panic("Vault not found in senderAccount")
        self.senderFlowVault = getAccount(senderAccount)
            .getCapability(/public/FlowVault)
            .borrow<&Token.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>()
            ?? panic("Flow vault not found in senderAccount")
        self.flowMinter = acct.borrow<&Token.Minter>(from: /storage/FlowMinter)
            ?? panic("Minter is not present")
    }
    execute {
        let newVault <- self.adminResource.adminGetCoin(senderVault: self.senderVault, amount: amount)        
        log(newVault.balance)
        self.signerVault.deposit(from: <-newVault)
        let newFlowVault <- self.flowMinter.mintTokens(amount: amount)
        self.senderFlowVault.deposit(from: <-newFlowVault)
        log("Done!!!")
    }
}
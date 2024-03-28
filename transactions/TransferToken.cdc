import FungibleToken from 0x05
import PrasToken from 0x05

transaction(receiverAccount: Address, amount: UFix64) {
    let signerVault: &PrasToken.Vault
    let receiverVault: &PrasToken.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        self.signerVault = acct.borrow<&PrasToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault not found in senderAccount")
        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&PrasToken.Vault{FungibleToken.Receiver}>()
            ?? panic("Vault not found in receiverAccount")
    }
    execute {
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens transferred")
    }
}
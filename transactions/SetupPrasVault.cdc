import FungibleToken from 0x05
import PrasToken from 0x05

transaction() {
    let userVault: &PrasToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, PrasToken.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&PrasToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, PrasToken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- PrasToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&PrasToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, PrasToken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}
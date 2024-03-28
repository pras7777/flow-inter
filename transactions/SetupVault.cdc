import FungibleToken from 0x05
import Token from 0x05

transaction() {

    let TokenVault: &Token.Vault?
    let account: AuthAccount

    prepare(acct: AuthAccount) {
        self.TokenVault = acct.getCapability(/public/FlowVault)
            .borrow<&Token.Vault>()

        self.account = acct
    }

    execute {
        if self.TokenVault == nil {
            let newVault <- Token.createEmptyVault()
            self.account.save(<-newVault, to: /storage/Vault)
            self.account.link<&Token.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}>(/public/Vault, target: /storage/Vault)
            log("Empty FlowToken vault created and linked")
        } else {
            log("FlowToken vault already exists and is properly linked")
        }
    }
}
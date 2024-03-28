import FungibleToken from 0x05
import PrasToken from 0x05

transaction(receiver: Address, amount: UFix64) {
    prepare(signer: AuthAccount) {
        let minter = signer.borrow<&PrasToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not an allowed Token minter")
        let receiverVault = getAccount(receiver)
            .getCapability<&PrasToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your Token Vault status")
        let mintedTokens <- minter.mintToken(amount: amount)  
        receiverVault.deposit(from: <-mintedTokens)
    }
    execute {
        log("Minted and deposited successfully")
        log(amount.toString().concat(" Tokens minted and deposited"))
    }
}
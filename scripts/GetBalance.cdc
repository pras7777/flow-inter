import FungibleToken from 0x05
import PrasToken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &PrasToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, PrasToken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&PrasToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, PrasToken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- PrasToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&PrasToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, PrasToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &PrasToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&PrasToken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &PrasToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, PrasToken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&PrasToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, PrasToken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if PrasToken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a PrasToken vault")
        } else {
            log("This is not a PrasToken vault")
        }
    }
}
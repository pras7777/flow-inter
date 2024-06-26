import FungibleToken from 0x05
import Token from 0x05

pub fun getFlowVaultBalance(account: Address): UFix64? {

    
    let publicFlowVault: &Token.Vault{FungibleToken.Balance}?
        = getAccount(account)
            .getCapability(/public/FlowVault)
            .borrow<&Token.Vault{FungibleToken.Balance}>()

    if let balance = publicFlowVault?.balance {
       
        return balance
    } else {
        return panic("Flow vault does not exist or borrowing failed")
    }
}
pub fun main(_account: Address): UFix64? {

    return getFlowVaultBalance(account: _account)
}
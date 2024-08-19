// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { Upgrades } from "openzeppelin-foundry-upgrades/Upgrades.sol";

import { INonceManager } from "account-abstraction/interfaces/INonceManager.sol";

import { CommunityModule } from "../src/Modules/Community/CommunityModule.sol";
import { Paymaster } from "../src/Modules/Community/Paymaster.sol";

contract AAModuleScript is Script {
	bytes constant AA_MODULE_DEPLOYED_CODE = bytes(hex"608060405234801561001057600080fd5b50600436106101355760003560e01c8063541d63c8116100b2578063b25f377611610081578063bd61951d11610066578063bd61951d14610347578063f23a6e611461035a578063f698da251461039357600080fd5b8063b25f3776146102f9578063bc197c811461030c57600080fd5b8063541d63c8146102ab5780636ac24784146102be5780637bb37428146102d1578063b2494df3146102e457600080fd5b8063150b7a021161010957806320c13b0b116100ee57806320c13b0b1461026557806323031640146102785780633a871cdd1461029857600080fd5b8063150b7a02146101e95780631626ba7e1461025257600080fd5b806223de291461013a57806301ffc9a7146101545780630a1028c41461017c578063137e051e1461019d575b600080fd5b610152610148366004611586565b5050505050505050565b005b610167610162366004611665565b6103ef565b60405190151581526020015b60405180910390f35b61018f61018a36600461179c565b6104d4565b604051908152602001610173565b6101c47f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278981565b60405173ffffffffffffffffffffffffffffffffffffffff9091168152602001610173565b6102216101f73660046117d9565b7f150b7a020000000000000000000000000000000000000000000000000000000095945050505050565b6040517fffffffff000000000000000000000000000000000000000000000000000000009091168152602001610173565b61022161026036600461184c565b6104e0565b610221610273366004611898565b610601565b61028b6102863660046118fc565b6107d7565b60405161017391906119b0565b61018f6102a63660046119dc565b61090e565b6101526102b9366004611a2a565b610c95565b61018f6102cc3660046118fc565b610e1f565b6101526102df366004611a2a565b610e3a565b6102ec610ff0565b6040516101739190611a9c565b61018f610307366004611af6565b61109a565b61022161031a366004611b70565b7fbc197c810000000000000000000000000000000000000000000000000000000098975050505050505050565b61028b610355366004611c0e565b6110bc565b610221610368366004611c4a565b7ff23a6e61000000000000000000000000000000000000000000000000000000009695505050505050565b61018f604080517f47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a794692186020820152469181019190915230606082015260009060800160405160208183030381529060405280519060200120905090565b60007fffffffff0000000000000000000000000000000000000000000000000000000082167f4e2312e000000000000000000000000000000000000000000000000000000000148061048257507fffffffff0000000000000000000000000000000000000000000000000000000082167f150b7a0200000000000000000000000000000000000000000000000000000000145b806104ce57507fffffffff0000000000000000000000000000000000000000000000000000000082167f01ffc9a700000000000000000000000000000000000000000000000000000000145b92915050565b60006104ce3383610e1f565b60408051602080820186905282518083039091018152818301928390527f20c13b0b000000000000000000000000000000000000000000000000000000009092526000913391839183916320c13b0b916105409189908990604401611d0f565b602060405180830381865afa15801561055d573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105819190611d3f565b90507fffffffff0000000000000000000000000000000000000000000000000000000081167f20c13b0b00000000000000000000000000000000000000000000000000000000146105d35760006105f5565b7f1626ba7e000000000000000000000000000000000000000000000000000000005b925050505b9392505050565b6000338161060f82866107d7565b80516020820120855191925090600003610725576040517f5ae6bd370000000000000000000000000000000000000000000000000000000081526004810182905273ffffffffffffffffffffffffffffffffffffffff841690635ae6bd3790602401602060405180830381865afa15801561068e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906106b29190611d5c565b600003610720576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601160248201527f48617368206e6f7420617070726f76656400000000000000000000000000000060448201526064015b60405180910390fd5b6107ac565b6040517f934f3a1100000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff84169063934f3a119061077b90849086908a90600401611d75565b60006040518083038186803b15801561079357600080fd5b505afa1580156107a7573d6000803e3d6000fd5b505050505b507f20c13b0b0000000000000000000000000000000000000000000000000000000095945050505050565b606060007f60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca60001b8380519060200120604051602001610821929190918252602082015260400190565b604051602081830303815290604052805190602001209050601960f81b600160f81b8573ffffffffffffffffffffffffffffffffffffffff1663f698da256040518163ffffffff1660e01b8152600401602060405180830381865afa15801561088e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906108b29190611d5c565b6040517fff00000000000000000000000000000000000000000000000000000000000000938416602082015292909116602183015260228201526042810182905260620160405160208183030381529060405291505092915050565b60007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec36013560601c7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278973ffffffffffffffffffffffffffffffffffffffff16146109d5576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601760248201527f556e737570706f7274656420656e74727920706f696e740000000000000000006044820152606401610717565b60006109e46020860186611da0565b905073ffffffffffffffffffffffffffffffffffffffff81163314610a65576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152600e60248201527f496e76616c69642063616c6c65720000000000000000000000000000000000006044820152606401610717565b610a726060860186611dbd565b610a7b91611e22565b7fffffffff00000000000000000000000000000000000000000000000000000000167f7bb37428000000000000000000000000000000000000000000000000000000001480610b205750610ad26060860186611dbd565b610adb91611e22565b7fffffffff00000000000000000000000000000000000000000000000000000000167f541d63c800000000000000000000000000000000000000000000000000000000145b610bac576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152602160248201527f556e737570706f7274656420657865637574696f6e2066756e6374696f6e206960448201527f64000000000000000000000000000000000000000000000000000000000000006064820152608401610717565b610bb58561111f565b91508215610c8d576040517f468721a700000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d2789811660048301526024820185905260806044830152600060848301819052606483015282169063468721a79060a4016020604051808303816000875af1158015610c67573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c8b9190611e7f565b505b509392505050565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec36013560601c7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278973ffffffffffffffffffffffffffffffffffffffff1614610d5a576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601760248201527f556e737570706f7274656420656e74727920706f696e740000000000000000006044820152606401610717565b6040517f5229073f00000000000000000000000000000000000000000000000000000000815260009081903390635229073f90610da1908990899089908990600401611e9a565b6000604051808303816000875af1158015610dc0573d6000803e3d6000fd5b505050506040513d6000823e601f3d9081017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0168201604052610e069190810190611ee3565b9150915081610e1757805160208201fd5b505050505050565b6000610e2b83836107d7565b80519060200120905092915050565b7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffec36013560601c7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d278973ffffffffffffffffffffffffffffffffffffffff1614610eff576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601760248201527f556e737570706f7274656420656e74727920706f696e740000000000000000006044820152606401610717565b6040517f468721a7000000000000000000000000000000000000000000000000000000008152339063468721a790610f41908790879087908790600401611e9a565b6020604051808303816000875af1158015610f60573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610f849190611e7f565b610fea576040517f08c379a000000000000000000000000000000000000000000000000000000000815260206004820152601060248201527f457865637574696f6e206661696c6564000000000000000000000000000000006044820152606401610717565b50505050565b6040517fcc2f845200000000000000000000000000000000000000000000000000000000815260016004820152600a60248201526060903390600090829063cc2f845290604401600060405180830381865afa158015611054573d6000803e3d6000fd5b505050506040513d6000823e601f3d9081017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0168201604052610c8d9190810190611f78565b6000806110a683611202565b5050505090508080519060200120915050919050565b60606040517fb4faba09000000000000000000000000000000000000000000000000000000008152600436036004808301376020600036836000335af1505060203d036040519150808201604052806020833e506000516105fa57805160208201fd5b60008060008036600061113187611202565b93985091965094509250905061114a6020880188611da0565b855160208701206040517f934f3a1100000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff929092169163934f3a11916111a99189908790879060040161203c565b60006040518083038186803b1580156111c157600080fd5b505afa9250505080156111d2575060015b6111e9576111e2600184866114e0565b95506111f8565b6111f5600084866114e0565b95505b5050505050919050565b606060008036818181611219610140890189611dbd565b909250905061122c600660008385612073565b6112359161209d565b60d01c9550611248600c60068385612073565b6112519161209d565b60d01c945061126381600c8185612073565b9350935050506000604051806101c001604052807f84aa190356f56b8c87825f54884392a9907c23ee0f8e1ea86336b763faf021bd81526020018860000160208101906112b09190611da0565b73ffffffffffffffffffffffffffffffffffffffff168152602001886020013581526020018880604001906112e59190611dbd565b6040516112f39291906120e3565b604051908190039020815260200161130e60608a018a611dbd565b60405161131c9291906120e3565b60405180910390208152602001886080013581526020018860a0013581526020018860c0013581526020018860e00135815260200188610100013581526020018880610120019061136d9190611dbd565b60405161137b9291906120e3565b6040805191829003909120825265ffffffffffff808916602084015287169082015273ffffffffffffffffffffffffffffffffffffffff7f0000000000000000000000005ff137d4b0fdcd49dca30c7cf57e578a026d2789166060909101526101c081209091507f19000000000000000000000000000000000000000000000000000000000000007f0100000000000000000000000000000000000000000000000000000000000000611480604080517f47e79534a245952e8b16893a336b85a3d9ea9fa8c573f3d803afb92a794692186020820152469181019190915230606082015260009060800160405160208183030381529060405280519060200120905090565b6040517fff0000000000000000000000000000000000000000000000000000000000000093841660208201529290911660218301526022820152604281018290526062016040516020818303038152906040529650505091939590929450565b600060d08265ffffffffffff16901b60a08465ffffffffffff16901b8561150857600061150b565b60015b60ff161717949350505050565b73ffffffffffffffffffffffffffffffffffffffff8116811461153a57600080fd5b50565b60008083601f84011261154f57600080fd5b50813567ffffffffffffffff81111561156757600080fd5b60208301915083602082850101111561157f57600080fd5b9250929050565b60008060008060008060008060c0898b0312156115a257600080fd5b88356115ad81611518565b975060208901356115bd81611518565b965060408901356115cd81611518565b955060608901359450608089013567ffffffffffffffff808211156115f157600080fd5b6115fd8c838d0161153d565b909650945060a08b013591508082111561161657600080fd5b506116238b828c0161153d565b999c989b5096995094979396929594505050565b7fffffffff000000000000000000000000000000000000000000000000000000008116811461153a57600080fd5b60006020828403121561167757600080fd5b81356105fa81611637565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b604051601f82017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe016810167ffffffffffffffff811182821017156116f8576116f8611682565b604052919050565b600067ffffffffffffffff82111561171a5761171a611682565b50601f017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe01660200190565b600082601f83011261175757600080fd5b813561176a61176582611700565b6116b1565b81815284602083860101111561177f57600080fd5b816020850160208301376000918101602001919091529392505050565b6000602082840312156117ae57600080fd5b813567ffffffffffffffff8111156117c557600080fd5b6117d184828501611746565b949350505050565b6000806000806000608086880312156117f157600080fd5b85356117fc81611518565b9450602086013561180c81611518565b935060408601359250606086013567ffffffffffffffff81111561182f57600080fd5b61183b8882890161153d565b969995985093965092949392505050565b60008060006040848603121561186157600080fd5b83359250602084013567ffffffffffffffff81111561187f57600080fd5b61188b8682870161153d565b9497909650939450505050565b600080604083850312156118ab57600080fd5b823567ffffffffffffffff808211156118c357600080fd5b6118cf86838701611746565b935060208501359150808211156118e557600080fd5b506118f285828601611746565b9150509250929050565b6000806040838503121561190f57600080fd5b823561191a81611518565b9150602083013567ffffffffffffffff81111561193657600080fd5b6118f285828601611746565b60005b8381101561195d578181015183820152602001611945565b50506000910152565b6000815180845261197e816020860160208601611942565b601f017fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0169290920160200192915050565b6020815260006105fa6020830184611966565b600061016082840312156119d657600080fd5b50919050565b6000806000606084860312156119f157600080fd5b833567ffffffffffffffff811115611a0857600080fd5b611a14868287016119c3565b9660208601359650604090950135949350505050565b60008060008060808587031215611a4057600080fd5b8435611a4b81611518565b935060208501359250604085013567ffffffffffffffff811115611a6e57600080fd5b611a7a87828801611746565b925050606085013560ff81168114611a9157600080fd5b939692955090935050565b6020808252825182820181905260009190848201906040850190845b81811015611aea57835173ffffffffffffffffffffffffffffffffffffffff1683529284019291840191600101611ab8565b50909695505050505050565b600060208284031215611b0857600080fd5b813567ffffffffffffffff811115611b1f57600080fd5b6117d1848285016119c3565b60008083601f840112611b3d57600080fd5b50813567ffffffffffffffff811115611b5557600080fd5b6020830191508360208260051b850101111561157f57600080fd5b60008060008060008060008060a0898b031215611b8c57600080fd5b8835611b9781611518565b97506020890135611ba781611518565b9650604089013567ffffffffffffffff80821115611bc457600080fd5b611bd08c838d01611b2b565b909850965060608b0135915080821115611be957600080fd5b611bf58c838d01611b2b565b909650945060808b013591508082111561161657600080fd5b600080600060408486031215611c2357600080fd5b8335611c2e81611518565b9250602084013567ffffffffffffffff81111561187f57600080fd5b60008060008060008060a08789031215611c6357600080fd5b8635611c6e81611518565b95506020870135611c7e81611518565b94506040870135935060608701359250608087013567ffffffffffffffff811115611ca857600080fd5b611cb489828a0161153d565b979a9699509497509295939492505050565b8183528181602085013750600060208284010152600060207fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0601f840116840101905092915050565b604081526000611d226040830186611966565b8281036020840152611d35818587611cc6565b9695505050505050565b600060208284031215611d5157600080fd5b81516105fa81611637565b600060208284031215611d6e57600080fd5b5051919050565b838152606060208201526000611d8e6060830185611966565b8281036040840152611d358185611966565b600060208284031215611db257600080fd5b81356105fa81611518565b60008083357fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1843603018112611df257600080fd5b83018035915067ffffffffffffffff821115611e0d57600080fd5b60200191503681900382131561157f57600080fd5b7fffffffff000000000000000000000000000000000000000000000000000000008135818116916004851015611e625780818660040360031b1b83161692505b505092915050565b80518015158114611e7a57600080fd5b919050565b600060208284031215611e9157600080fd5b6105fa82611e6a565b73ffffffffffffffffffffffffffffffffffffffff85168152836020820152608060408201526000611ecf6080830185611966565b905060ff8316606083015295945050505050565b60008060408385031215611ef657600080fd5b611eff83611e6a565b9150602083015167ffffffffffffffff811115611f1b57600080fd5b8301601f81018513611f2c57600080fd5b8051611f3a61176582611700565b818152866020838501011115611f4f57600080fd5b611f60826020830160208601611942565b8093505050509250929050565b8051611e7a81611518565b60008060408385031215611f8b57600080fd5b825167ffffffffffffffff80821115611fa357600080fd5b818501915085601f830112611fb757600080fd5b8151602082821115611fcb57611fcb611682565b8160051b9250611fdc8184016116b1565b8281529284018101928181019089851115611ff657600080fd5b948201945b84861015612020578551935061201084611518565b8382529482019490820190611ffb565b965061202f9050878201611f6d565b9450505050509250929050565b8481526060602082015260006120556060830186611966565b8281036040840152612068818587611cc6565b979650505050505050565b6000808585111561208357600080fd5b8386111561209057600080fd5b5050820193919092039150565b7fffffffffffff00000000000000000000000000000000000000000000000000008135818116916006851015611e625760069490940360031b84901b1690921692915050565b818382376000910190815291905056fea264697066735822122073b2f06a452916e599e0f5dddf12e282a21ffb83a30811b2fbe9fd7ce48dc3a064736f6c63430008170033");

	function deploy() public returns (address) {
		uint256 deployerPrivateKey = isAnvil()
            ? 77_814_517_325_470_205_911_140_941_194_401_928_579_557_062_014_761_831_930_645_393_041_380_819_009_408
            : vm.envUint("PRIVATE_KEY");
		address deployer = vm.addr(deployerPrivateKey);

		vm.startBroadcast(deployerPrivateKey);

		if (isAnvil()) {
            vm.deal(vm.addr(deployerPrivateKey), 100 ether);
        }

		address aaModule = address(0xa581c4A4DB7175302464fF3C06380BC3270b4037);

		vm.etch(aaModule, AA_MODULE_DEPLOYED_CODE);

		vm.stopBroadcast();

		return aaModule;
	}

	function isAnvil() private view returns (bool) {
        return block.chainid == 31_337;
    }
}
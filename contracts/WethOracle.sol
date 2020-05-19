pragma solidity ^0.6.2;
import "@hq20/contracts/contracts/math/DecimalMath.sol";
import "./interfaces/IVat.sol";
import "./interfaces/IOracle.sol";
import "./Constants.sol";


/// @dev WethOracle returns the price of Weth as retrieved from MakerDAO
contract WethOracle is IOracle, Constants {
    using DecimalMath for uint256;
    IVat public _vat;

    /// @dev To calculate price we retrieve rate and spot from Vat
    constructor (address vat_) public {
        _vat = IVat(vat_);
    }

    /// @dev Price is (spot / rate)
    /// collateral = price * dai
    function price() public override returns(uint256) {
        (,uint256 rate, uint256 spot,,) = _vat.ilks("ETH-A");  // Stability fee and collateralization ratio for Weth
        return spot.divd(rate, RAY);
    }
}
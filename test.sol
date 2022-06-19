pragma solidity 0.8.15;

contract Test {

    // 5 loops, total gas cost == 22138
    // 100 loops, total gas cost == 27743
    // 1000 loops, total gas cost == 80855
    function increment0(uint256 loops) external pure returns (uint256) {
        uint256 value;
        for (uint256 i; i < loops;) {
            unchecked { ++i; }
            value = i;
        }
        return value;
    }

    // 5 loops, total gas cost == 22051
    // 100 loops, total gas cost == 26326
    // 1000 loops, total gas cost == 66838
    function increment1(uint256 loops) external pure returns (uint256) {
        uint256 value;
        for (uint256 i;;) {
            unchecked { ++i; }
            value = i;
            if (i >= loops) break;
        }
        return value;
    }

    // 5 loops, total gas cost == 22019
    // 100 loops, total gas cost == 26294
    // 1000 loops, total gas cost == 66806
    function increment2(uint256 loops) external pure returns (uint256) {
        uint256 value;
        for (uint256 i;;) {
            unchecked { i += 1; } // i += 1 cheaper than ++i
            value = i;
            if (i >= loops) break;
        }
        return value;
    }

}
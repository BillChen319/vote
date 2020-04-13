pragma solidity >=0.6.0 <0.7.0;

// 智能合约投票：创建投票人与候选人，默认每个人只能投一票，而且不能重复投票

// 候选人不能参与投票
contract VoteDemo{
    
    address internal _owner;
    
    // 创建构造函数
    constructor()public{
       _owner = msg.sender;
    }
    
    // 创建投票人结构体:采用bool来表示投票状态
    struct Voter{
        address addr; // 投票人地址
        bool vote;  //投票状态(限制重复投票)
        uint amount;  // 投票数默认为1
    }
    
    // 创建一个候选人结构图
    struct Candidate{
        address addr;   // 候选人地址
        uint get;    // 得到的票数
        bool win;   // 候选人是否获胜
    }
    
    // 一个投票人只能投一个候选者人，但一个候选人可以接收多个投票人
    
    // 采用映射存储投票人与候选人
    mapping (address => Voter) public voters;
    // 候选人映射
    mapping (address => Candidate) public candidates;
    
    // 初始化候选人
    function initCandidate(address addr) public{
        candidates[addr] = Candidate(addr,0,false);
    }
    
    event showData(string);
    
    // 初始化投票人
    function initVote(address addr) public{
        // 避免重复初始化
        if(voters[addr].addr != address(0)){
            emit showData("此人已被初始化");
            return;
        }
        voters[addr] = Voter({addr:addr,vote:false,amount:1});
    }
    
    // 当前函数完成投票的业务逻辑
    // 调用函数的人就是投票人, 投票时需要传入候选人的地址
    function vote(address candidate)public{
         Voter storage v =  voters[msg.sender];
         // 判断此人没有重复投票,且不是候选人
         if(v.vote || v.addr == candidate){
             emit showData('此人不具备投票资格!');
             return;
         }
         // 给候选人进行投票
         candidates[candidate].get += v.amount;
         // 更新投票人的状态
         v.vote = true;
    }
    
    // 创建修饰器
    modifier checkOwner{
        if(msg.sender!=_owner){
            revert();
        }
        _;
    }
    
    // 判断成功的投票人
    function success(address addr1,address addr2) public checkOwner returns (address) {
        if(candidates[addr1].get > candidates[addr2].get){
            candidates[addr1].win = true;
            return addr1;
        }else{
            candidates[addr2].win = true;
            return addr2;
        }
    }
    
}
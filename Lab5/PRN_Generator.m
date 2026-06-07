function Code=PRN_Generator(PRN_Code_Number,Nc)
Phase_Selector=[2,6
    3,7
    4,8
    5,9
    1,9
    2,10
    1,8
    2,9
    3,10
    2,3
    3,4
    5,6
    6,7
    7,8
    8,9
    9,10
    1,4
    2,5
    3,6
    4,7
    5,8
    6,9
    1,3
    4,6
    5,7
    6,8
    7,9
    8,10
    1,6
    2,7
    3,8
    4,9];
Selected_Phases=Phase_Selector(PRN_Code_Number,:);
%%
m=10;
p=2^m-1;
p=p*Nc;
C1=ones(1,m)*(-1);
C2=ones(1,m)*(-1);
Counter=1;
C_A_Code=zeros(1,p);
%%
while (Counter<=p)
    % C1 Code
    Bit_3_C1=C1(3);
    Bit_10_C1=C1(10);
    Feed_Bit_C1=Bit_3_C1*Bit_10_C1;
    % C2 Code
    Bit_2_C2=C2(2);
    Bit_3_C2=C2(3);
    Bit_6_C2=C2(6);
    Bit_8_C2=C2(8);
    Bit_9_C2=C2(9);
    Bit_10_C2=C2(10);
    Feed_Bit_C2=Bit_2_C2*Bit_3_C2*Bit_6_C2*Bit_8_C2*Bit_9_C2*Bit_10_C2;
    % C/A Code
    Code(Counter)=C2(Selected_Phases(1))*C2(Selected_Phases(2))*Bit_10_C1;
    % Shifting operations
    C1=circshift(C1,1);
    C2=circshift(C2,1);
    % Placing feedback bits before new loop
    C1(1)=Feed_Bit_C1;
    C2(1)=Feed_Bit_C2;
    Counter=Counter+1;
end
end
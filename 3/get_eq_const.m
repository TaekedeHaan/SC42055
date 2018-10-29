function [Aeq, beq] = get_eq_const(case_name)

switch case_name
        case '4_full_controll'
            % equalities: NONE
            Aeq = [];
            beq = [];
        case '4_no_control'
            % equalities: 
            % 1) V_sl = x(11) = 120
            % 2) r = x(10) = 1
            Aeq = zeros(2,11);
            Aeq(1,11) = 1;
            Aeq(2,10) = 1;
            beq = [120, 1]';
end

end
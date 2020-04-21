initCobraToolbox
changeCobraSolver('ibm_cplex','all');

%%find essential input metabolites
result_input=cell(length(models),1);
result_essential_input_reactions=cell(length(models),1);
result_essential_input_reactions_name=cell(length(models),1);
result_essential_input_formula=cell(length(models),1);
result_essential_input_metabolites=cell(length(models),1);
cut_off= 0.8;
for i=1:length(models)
    model=models{i};
    solution = optimizeCbModel(model);
    optimal_obj = solution.obj;
    exchange_idx=find(findExcRxns(model)==1);
    exchange_rxn = model.rxns(exchange_idx);
    temp_array=[];
    for j=1:length(exchange_rxn)     
        model_temp = changeRxnBounds(models{i},exchange_rxn(j),0,'l');
        solution = optimizeCbModel(model_temp);
        if solution.obj <= optimal_obj*cut_off
            temp_array(j)=1;
        else
            temp_array(j)=0;
        end
    end
    result_input{i}=temp_array;
end

for i=1:length(models)
    model=models{i};
    exchange_idx=find(findExcRxns(model)==1); %exchange reaction index
    essential_input_idx=find(result_input{i}==1); %input_result index
    result_essential_input_reactions{i}=model.rxns(exchange_idx(essential_input_idx));
    result_essential_input_reactions_name{i}=model.rxnNames(exchange_idx(essential_input_idx));
    rxn_formula = printRxnFormula(model);
    result_essential_input_formula{i} = rxn_formula(exchange_idx(essential_input_idx));
    result_essential_input_metabolites_temp = strrep(result_essential_input_formula{i},' -> ','');
    result_essential_input_metabolites_temp = strrep(result_essential_input_metabolites_temp,' <=> ','');
    result_essential_input_metabolites_temp = strrep(result_essential_input_metabolites_temp,'+ ','');
    result_essential_input_metabolites_temp = strrep(result_essential_input_metabolites_temp,' ','');
    [a,b,c] = find(strcmp(repmat(model.mets,1,length(result_essential_input_metabolites_temp)),repmat(result_essential_input_metabolites_temp',length(model.mets),1)));
    result_essential_input_metabolites{i}=model.metNames(a);
end

%%find essential output metabolites
result_output=cell(length(models),1);
result_essential_output_reactions=cell(length(models),1);
result_essential_output_reactions_name=cell(length(models),1);
result_essential_output_formula=cell(length(models),1);
result_essential_output_metabolites=cell(length(models),1);
cut_off= 0.8;
for i=1:length(models)
    model=models{i};
    solution = optimizeCbModel(model);
    optimal_obj = solution.obj;
    exchange_idx=find(findExcRxns(model)==1);
    exchange_rxn = model.rxns(exchange_idx);
    temp_array=[];
    for j=1:length(exchange_rxn)     
        model_temp = changeRxnBounds(models{i},exchange_rxn(j),0,'u');
        solution = optimizeCbModel(model_temp);
        if solution.obj <= optimal_obj*cut_off
            temp_array(j)=1;
        else
            temp_array(j)=0;
        end
    end
    result_output{i}=temp_array;
end

for i=1:length(models)
    model=models{i};
    exchange_idx=find(findExcRxns(model)==1);
    essential_output_idx=find(result_output{i}==1);
    result_essential_output_reactions{i}=model.rxns(exchange_idx(essential_output_idx));
    result_essential_output_reactions_name{i}=model.rxnNames(exchange_idx(essential_output_idx));
    rxn_formula = printRxnFormula(model);
    result_essential_output_formula{i} = rxn_formula(exchange_idx(essential_output_idx));
    result_essential_output_metabolites_temp = strrep(result_essential_output_formula{i},' -> ','');
    result_essential_output_metabolites_temp = strrep(result_essential_output_metabolites_temp,' <=> ','');
    result_essential_output_metabolites_temp = strrep(result_essential_output_metabolites_temp,'+ ','');
    result_essential_output_metabolites_temp = strrep(result_essential_output_metabolites_temp,' ','');
    [a,b,c] = find(strcmp(repmat(model.mets,1,length(result_essential_output_metabolites_temp)),repmat(result_essential_output_metabolites_temp',length(model.mets),1)));
    result_essential_output_metabolites{i}=model.metNames(a);

end



require "yarrrml-template-builder"

# THIS IS FOR PROM-STYLE QUESTIONNAIRES

#pid,uniqid,hp_uri,hp_label,hgvs_uri,hgvs_string,date

b = YARRRML_Template_Builder.new({
  source_tag: "undiagnosed",
  sio_verbose: 1,
  }
  )

b.person_identifier_role_mappings({
                                    personid_column: "pid",
                                    uniqueid_column: "uniqid",
                                    person_role_tag: "patientRole",
                                    role_type: 'http://purl.obolibrary.org/obo/OBI_0000093',
                                    role_label: "Patient"
                                    })

b.role_in_process({
    person_role_tag: "patientRole_diagnosis",
    process_tag:  "medical_diagnosis",
    process_label: "medical diagnosis", 
    process_type: "http://semanticscience.org/resource/SIO_001001",  # medical diagnosis
    process_start_column: "date", 
    })


# @param [:process_with_output_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the output
# @param [:output_value] (string)  (optional) the default value of that output (defaults to nil, and the output node is not created in the RDF)
# @param [:output_value_column] (string)  (optional) the column header for the value of that output (e.g. the column that contains "80"  for "80 mmHg")
# @param [:output_type] (URL) the URL associated with the output ontological type (defaults to http://semanticscience.org/resource/realizable-entity)
# @param [:output_type_column] (string) the column header for the URL associated with the output ontological type (overrides output_type)
# @param [:output_type_label] (string) (optional) the the label of that ontological type (defaults to "measurement-value")
# @param [:output_type_label_column] (string) (optional) the column header for the label of that ontological type (overrides output_type_label)
# @param [:output_value_datatype] (xsd:type)  (optional) the xsd:type for that kind of measurement (defaults to xsd:string)
# @param [:output_value_datatype_column] (string)  (optional) the column header for the xsd:type for that kind of measurement (overrides output_value_datatype)
# @param [:output_comments_column] (string)  (optional) the column header for amy textual comments.  text must not contain a comma!!  defaults to nil
# @param [:output_start_column] (xsd:datetime)  (optional) the column header for start date
# @param [:output_end_column] (xsd:datetime)  (optional) the column header for end date

b.process_hasoutput_output({
    process_with_output_tag: "medical_diagnosis",  # connect to the correct process
    #output_type: "Undiagnosed",
    output_type_label: "Undiagnosed",
    })

b.input_output_refers_to({
  inout_process_tag:   "medical_diagnosis",  # connect to the correct process
  refers_to_tag: "undiagnosed_attribute",
  inout_refers_to: "http://purl.obolibrary.org/obo/NCIT_C113725",
  inout_refers_to_label: "Undiagnosed",
  is_attribute: true,
})


# @param [:process_with_input_tag] (string) (required) the same process tag that is used in the "role in process" for which this is the input
# @param [:input_is_output_of_process_tag] (string) defaults to 'unidentifiedProcess'; if the input is the output of another process, then specify the process tag here (matches the "role in process" which generates taht output
# @param [:input_type] (string) the ontological type for the input node (default http://semanticscience.org/resource/information-content-entity).  Ignored if using output from another process (specify it there!)
# @param [:input_type_tag] (string) some single-word tag for that input (default thisInput).  required if more than one input!
# @param [:input_type_column] (string) the column header specifying the ontological type for the input node (overrides input_type).  Ignored if using output from another process (specify it there!)
# @param [:input_type_label] (string) the label for all inputs
# @param [:input_type_label_column] (string) the label column for each input
# @param [:input_label_tag] (string) some single-word tag for that input (default thisInput).  required if more than one input!
# @param [:input_has_value] (string) the value of the input
# @param [:input_has_value_column] (string) the column containing the value of the input
# @param [:input_has_value_datatype] (string) datatype of the value (default xsd:string)
# @param [:input_has_value_datatype_column] (string) the column containing the datatype of the value of the input )(overrides input_has_value_datatype)

#pid,uniqid,processLabel,processURI,startDate,comments,measurementURI,measurementLabel,promURI,data,promQuestion,ontologyURI

b.process_has_input({
  process_with_input_tag: "medical_diagnosis",
  input_is_output_of_process_tag: "phenotyping_input",
  input_type_column: "hp_uri", 
  input_type_label_column: "hp_label", 
  input_type_tag: "HP_Phenotype",
}
)

b.process_has_input({
  process_with_input_tag: "medical_diagnosis",  # connect to the correct process
  input_is_output_of_process_tag: "genotyping_input",
  input_type_column: "clinvar_uri",  # genomic sequence variant
  input_type_label_column: "hgvs_string",
  input_type_tag: "HGVS_Genotype",
})



puts b.generate
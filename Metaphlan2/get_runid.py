#!/usr/bin/env python
# coding: utf-8
#This script is for getting run files for the same sample according to correspondence information
import xml.etree.ElementTree as ET
from xml.etree.ElementTree import parse
import re
import sys
doc = parse('./ERS328716-ERS329007.xml')
root = doc.getroot()
dic = {}
for sample in doc.iter(tag='SAMPLE'):
    identifier = sample.find('IDENTIFIERS')
    sample_id = identifier.findtext('SUBMITTER_ID')
    sample_links = sample.find('SAMPLE_LINKS')
    run = sample_links.findall('SAMPLE_LINK')
    run_id = run[2][0][1].text
    dic[sample_id]=run_id

def runid(sampleid):
    a = dic[sampleid]
    p = r"\d+"
    pattern = re.compile(p)
    number = pattern.findall(a)
    if len(number) >= 2:
        list_number = []
        gap = int(number[1]) - int(number[0])
        i = 0
        while i <= gap:
            list_number.append(str(int(number[0])+i))
            i = i+1
        return list_number
    else:
        return number

if __name__ == '__main__':
    output = runid(sys.argv[1])
    output_str = ''
    for i in output:
        output_str = output_str +' '+i
    print output_str







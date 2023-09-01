import numpy as np
import matplotlib.pyplot as plt
import sys

x = range(1,65)

vec_before = [0.03297280999631951, 0.014190266224680557, 0.011521256342159402, 0.009145402936671527, 0.01158770638108256, 0.023847209372476245, 0.033037642550533396, 0.0019539029892239133, 0.015904989567312764, 0.022265024943982557, 0.0019614425069368648, 0.02478109974234824, 0.002968392122151762, 0.024014062197387876, 0.02140605452099251, 0.03193837081796524, 0.01792118643079374, 0.010873408924589352, 0.005461874096688184, 0.007557116646664217, 0.018498152093338036, 0.00895669342713023, 0.009818274515565726, 0.0006811733156998956, 0.02729225923556553, 0.015133175764651716, 0.01359102837570211, 0.00236934785303834, 0.024113829720795576, 0.0038278704506909083, 0.012568543081083315, 0.02719793476238963, 0.00964614772392066, 0.01958586389594792, 0.03115725870437939, 0.026322946241498862, 0.00555640189817154, 0.00832595563251447, 0.00902499607410029, 0.02872300462557752, 0.03238566108775184, 0.003756602518541705, 0.0034285542393608457, 0.022212670106909308, 0.008611508301948321, 0.032203921103830656, 0.032223863467783734, 0.0012772732044111885, 0.021302774669406967, 0.023030405386548297, 0.015866676627333248, 0.023360632863182438, 0.021714219255094973, 0.014005233370117987, 0.0262318686528401, 0.0033159449413097163, 0.003958781128291855, 0.02375674774696781, 0.005162982889491953, 0.0004948695643978399, 0.0015881354071968956, 0.018447030473499326, 0.028891523733945945, 0.005072042557115095]
vec_after = [0.028754870870164383, 0.01949142069833181, 0.017217819536909696, 0.011739945426307559, 0.019863135365805334, 0.013601023965938397, 0.010668733247264701, 0.0017039563250518875, 0.0192269676978787, 0.017220087180141445, 0.01088534779157418, 0.012642573949837891, 0.017200334206059785, 0.018787811306382678, 0.010806348024686467, 0.010299648540316573, 0.021137803579275114, 0.016877725877274617, 0.015853787635644545, 0.015482651542636184, 0.017719575357012237, 0.015426888883905246, 0.012717183906082877, 0.009957287237449746, 0.015594457808922883, 0.013197313635587645, 0.01208101623815625, 0.01357635045165279, 0.014726332067051883, 0.015437428991283631, 0.01096075321948569, 0.011865370276612363, 0.02049502016650274, 0.01884362017483574, 0.01250314901598289, 0.014839868129863815, 0.019679737884287778, 0.02005586377500672, 0.013644653866341951, 0.011917449764725281, 0.014152171666304857, 0.01941969610708009, 0.0029899676259069587, 0.012134064309034765, 0.019791410774553608, 0.02808433958030797, 0.011062852129991906, 0.01693044898411409, 0.01912532069211207, 0.018759852172229224, 0.016486251010807113, 0.020372300131566153, 0.018936498611929076, 0.018968291874472815, 0.01603600115579912, 0.016270605049263226, 0.0156514305396101, 0.016843174326383468, 0.010508434937816205, 0.015634437381336602, 0.017685023806121088, 0.02085043302647951, 0.012868969744783293, 0.015736710743764853]

plt.plot(x,vec_before,label="initial random state",color="skyblue",marker='o')
plt.plot(x,vec_after,label="after 10^7 multiplication",color="cyan",marker='o')

plt.legend()
plt.xlabel("configuration")
plt.ylabel("element")
plt.show()

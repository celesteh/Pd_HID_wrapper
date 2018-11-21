(

var remote, hid, set_usage;

HID.findAvailable;
HID.postAvailable;
HID.debug = true;

set_usage = {
	HIDdef.usage(\all, {|value, raw, usage, page, id, element|

		remote.notNil.if({
			remote.sendMsg("/hid", "raw", id, value);
		})
	});
};

OSCdef(\info, {|msg, time, addr, recvPort|

	remote.isNil.if({
		remote = NetAddr(addr.ip, recvPort +1);
	});
	HID.available.do({|item, key|
		remote.sendMsg("/hid", "info", key.asInt, item.asString);
	});
}, '/hid_info'); // def style


OSCdef(\open, {|msg, time, addr, recvPort|
	//msg.postln;
	msg[1].asInt.postln;
	hid = HID.openAt(msg[1].asInt);
	hid.postInfo;
	hid.postInputElements;
	hid.action={|foo| foo.dump};
	HID.debug=false;
	set_usage.value();

}, '/hid_open');



)



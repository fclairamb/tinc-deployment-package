NETNAME=myvpn

ifeq "$(DESTDIR)" ""
	DESTDIR="target"
endif

ifeq "$(TARGET)" ""
	TARGET="root@localhost"
endif

all:
	echo "Hello"

install:
	mkdir -p $(DESTDIR)/etc/tinc/$(NETNAME)/hosts
	cp hosts/* $(DESTDIR)/etc/tinc/$(NETNAME)/hosts

	mkdir -p $(DESTDIR)/etc/tinc/$(NETNAME)/conf.d/
	cp conf.d/* $(DESTDIR)/etc/tinc/$(NETNAME)/conf.d/

	mkdir -p $(DESTDIR)/etc/cron.d
	cp cron-tasks/* $(DESTDIR)/etc/cron.d

	mkdir -p $(DESTDIR)/usr/sbin
	cp sbin/* $(DESTDIR)/usr/sbin && chmod a+rx $(DESTDIR)/usr/sbin/*

package:
	dpkg-buildpackage -b -us -uc
	rm -Rf dist/package || printf ""
	mkdir -p dist/package
	mv ../*.deb dist/package
	rm ../$(NETNAME)-vpn_*.*

deploy-local: package
	sudo dpkg -i dist/package/*.deb

deploy-vm:
	make deploy-remote TARGET=root@192.168.1.142

deploy-remote:
	ls dist/package/*.deb || make package
	scp dist/package/*.deb $(TARGET):/tmp/$(NETNAME)-vpn.deb
	ssh $(TARGET) "apt-get install -y tinc ; dpkg -i /tmp/$(NETNAME)-vpn.deb"

clean:
	rm -Rf dist || printf "Already cleaned up"

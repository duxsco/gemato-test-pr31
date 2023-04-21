FROM gentoo/stage3:latest

ARG GNUPG_VERSION
ARG PATCH_GEMATO

COPY standard-resolver.patch /etc/portage/patches/app-portage/gemato/

WORKDIR /tmp

RUN export GNUPGHOME="$(mktemp -d)" && \
    gpg --auto-key-locate clear,wkd --locate-external-keys --quiet infrastructure@gentoo.org && \
    gpg --import-ownertrust --quiet <<< "DCD05B71EAB94199527F44ACDB6B8C1F96D8BF6D:6:" && \
    curl -fsSL --remote-name-all https://distfiles.gentoo.org/snapshots/gentoo-latest.tar.xz{,.gpgsig} && \
    GPG_STATUS="$(gpg --batch --status-fd 1 --verify gentoo-latest.tar.xz.gpgsig gentoo-latest.tar.xz)" && \
    grep -E -q "^\[GNUPG:\][[:space:]]+GOODSIG[[:space:]]+" <<< "${GPG_STATUS}" && \
    grep -E -q "^\[GNUPG:\][[:space:]]+VALIDSIG[[:space:]]+" <<< "${GPG_STATUS}" && \
    grep -E -q "^\[GNUPG:\][[:space:]]+TRUST_ULTIMATE[[:space:]]+" <<< "${GPG_STATUS}" && \
    tar --transform 's#^gentoo-[0-9]\{8\}#gentoo#' -C /var/db/repos/ -xpJf /tmp/gentoo-latest.tar.xz && \
    gpgconf --kill all && \
    unset GNUPGHOME GPG_STATUS && \
    rm -rf /tmp/* && \
    echo "app-crypt/gnupg ~*" > /etc/portage/package.accept_keywords/main

RUN emerge -1 "=app-crypt/gnupg-${GNUPG_VERSION}" ${PATCH_GEMATO:+app-portage/gemato}


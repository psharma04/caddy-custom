ARG CADDY_VERSION=2.11

FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare --with github.com/corazawaf/coraza-caddy/v2 --with pkg.jsn.cam/caddy-defender --with github.com/ueffel/caddy-brotli --with github.com/greenpau/caddy-security --with github.com/mholt/caddy-l4 --with github.com/caddyserver/transform-encoder --with github.com/hslatman/caddy-crowdsec-bouncer/http@main --with github.com/hslatman/caddy-crowdsec-bouncer/appsec@main --with github.com/hslatman/caddy-crowdsec-bouncer/layer4@main --with github.com/porech/caddy-maxmind-geolocation  --with github.com/mholt/caddy-ratelimit --with github.com/caddyserver/cache-handler

FROM caddy:${CADDY_VERSION}

RUN apk update && apk add --no-cache git git-daemon cgit python3 py3-pygments py3-markdown py3-docutils groff curl dcron

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY update_geodb.sh /usr/local/bin/update_geodb.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/update_geodb.sh \
    && echo "0 0 */3 * * /usr/local/bin/update_geodb.sh > /proc/1/fd/1 2>/proc/1/fd/2" | crontab -

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

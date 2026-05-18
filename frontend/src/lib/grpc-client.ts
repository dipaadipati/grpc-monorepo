import { createClient, type Interceptor } from "@connectrpc/connect";
import { createConnectTransport } from "@connectrpc/connect-web";
import { AuthService, MemberService, OfferingService, PlanService, TenantService, TransactionService } from "@/gen/app_pb";

const clientAuthInterceptor: Interceptor = (next) => async (req) => {
    if (typeof document !== 'undefined') {
        const token = document.cookie.split("; ").find(row => row.startsWith("token="))?.split("=")[1];
        if (token) {
            req.header.set("Authorization", `Bearer ${token}`);
        }
    }
    return await next(req);
};

const transport = createConnectTransport({
    // baseUrl: "https://grpc-api.moora.web.id",
    baseUrl: "http://127.0.0.1:50051",
    useBinaryFormat: true,
    interceptors: [clientAuthInterceptor]
});

export const authClient = createClient(AuthService, transport);

export function createAuthenticatedClients(token: string) {
    const serverAuthInterceptor: Interceptor = (next) => async (req) => {
        req.header.set("Authorization", `Bearer ${token}`);
        return await next(req);
    };

    const serverTransport = createConnectTransport({
        // baseUrl: "https://grpc-api.moora.web.id",
        baseUrl: "http://127.0.0.1:50051",
        useBinaryFormat: true,
        interceptors: [serverAuthInterceptor]
    });

    return {
        authClient: createClient(AuthService, serverTransport),
        memberClient: createClient(MemberService, serverTransport),
        tenantClient: createClient(TenantService, serverTransport),
        planClient: createClient(PlanService, serverTransport),
        transactionClient: createClient(TransactionService, serverTransport),
        offeringClient: createClient(OfferingService, serverTransport),
    };
}
import { INestApplication } from "@nestjs/common";
import { ConnectRouter, ConnectError, Code } from "@connectrpc/connect";
import { AuthController } from "./controllers/auth.controller.js";
import {
    TenantService,
    AuthResponse,
    AuthService,
    GetMemberProfileRequest,
    LoginRequest, MemberService, RegisterMemberRequest, AddTenantRequest, UpdateTenantRequest, GetTenantRequest, PlanService, AddPlanRequest, UpdatePlanRequest, GetPlanRequest, TransactionService, CreateTransactionRequest, GetTransactionsRequest,
    OfferingService,
    AddOfferingRequest,
    UpdateOfferingRequest,
    GetOfferingRequest
} from "@/gen/app_pb";
import { MemberController } from "./controllers/member.controller.js";
import { TenantController } from "./controllers/tenant.controller.js";
import { PlanController } from "./controllers/plan.controller.js";
import { TransactionController } from "./controllers/transaction.controller.js";
import { OfferingController } from "./controllers/offering.controller.js";

export const registerConnectRoutes = (app: INestApplication, router: ConnectRouter) => {
    const auth = app.get(AuthController);
    const member = app.get(MemberController);
    const tenant = app.get(TenantController);
    const plan = app.get(PlanController);
    const transaction = app.get(TransactionController);
    const offering = app.get(OfferingController);

    const wrap = (fn: Function) => async (req: any, context: any) => {
        try {
            return await fn(req, context);
        } catch (err: any) {
            const message = err.message || "Internal Error";
            const code = err.error?.code ?? err.code ?? Code.Internal;
            throw new ConnectError(message, code);
        }
    };

    router.service(AuthService, {
        login: wrap((req: LoginRequest) => auth.login(req)),
        getProfile: wrap((_: any, context: any) => auth.getProfile(_, context)),
        logout: wrap((_: any, context: any) => auth.logout(_, context)),
    });

    router.service(MemberService, {
        registerMember: wrap((req: RegisterMemberRequest, context: any) => member.createMember(req, context)),
        updateMember: wrap((req: any, context: any) => member.updateMember(req, context)),
        deleteMember: wrap((req: GetMemberProfileRequest, context: any) => member.deleteMember(req, context)),
        getMembers: wrap((_: any, context: any) => member.getMembers(_, context)),
        getMemberProfile: wrap((req: GetMemberProfileRequest, context: any) => member.getMemberProfile(req, context)),
    });

    router.service(TenantService, {
        addTenant: wrap((req: AddTenantRequest, context: any) => tenant.addTenant(req, context)),
        updateTenant: wrap((req: UpdateTenantRequest, context: any) => tenant.updateTenant(req, context)),
        deleteTenant: wrap((req: GetTenantRequest, context: any) => tenant.deleteTenant(req, context)),
        getTenants: wrap((_: any, context: any) => tenant.getTenants(_, context)),
        getTenant: wrap((req: GetTenantRequest, context: any) => tenant.getTenant(req, context)),
    });

    router.service(PlanService, {
        addPlan: wrap((req: AddPlanRequest, context: any) => plan.addPlan(req, context)),
        updatePlan: wrap((req: UpdatePlanRequest, context: any) => plan.updatePlan(req, context)),
        deletePlan: wrap((req: GetPlanRequest, context: any) => plan.deletePlan(req, context)),
        getPlans: wrap((_: any, context: any) => plan.getPlans(_, context)),
        getPlan: wrap((req: GetPlanRequest) => plan.getPlan(req)),
    });

    router.service(TransactionService, {
        createTransaction: wrap((req: CreateTransactionRequest, context: any) => transaction.createTransaction(req, context)),
        getTransactions: wrap((req: GetTransactionsRequest, context: any) => transaction.getTransactions(req, context)),
        getFinanceSummary: wrap((req: GetTransactionsRequest, context: any) => transaction.getFinanceSummary(req, context)),
    });

    router.service(OfferingService, {
        addOffering: wrap((req: AddOfferingRequest, context: any) => offering.createOffering(req, context)),
        updateOffering: wrap((req: UpdateOfferingRequest, context: any) => offering.updateOffering(req, context)),
        deleteOffering: wrap((req: GetOfferingRequest, context: any) => offering.deleteOffering(req, context)),
        getOfferings: wrap((_: any, context: any) => offering.getOfferings(_, context)),
        getOffering: wrap((req: GetOfferingRequest, context: any) => offering.getOffering(req, context)),
    });

};